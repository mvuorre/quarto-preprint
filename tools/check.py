# /// script
# requires-python = ">=3.11"
# dependencies = ["pyyaml", "pypdfium2", "pillow"]
# ///
"""Render the test documents, check their expectations, and compare them with a git ref.

    uv run tools/check.py              # render the working tree and check expectations
    uv run tools/check.py --ref main   # ...and compare every page with `main`

Each run writes to a new folder, _build/<timestamp>/. Open report.html there: it lists
failed expectations, render errors, Typst warnings and, with --ref, every changed page
(before, after, and the changes in red). The same list, without images, is printed.

Expectations live in each document's front matter, under `expect:`:

    expect:
      pairs: true                # every "• X: Y" list item must have X == Y
      contains: ["Anhang B"]     # text that must appear (whitespace-insensitive)
      absent: ["Figure"]         # text that must not appear
"""

import argparse
import datetime
import html
import io
import re
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path

import pypdfium2 as pdfium
import yaml
from PIL import Image, ImageChops

REPO = Path(__file__).resolve().parent.parent
SCALE = 1.5  # page images at 108 dpi
ANSI = re.compile(r"\x1b\[[0-9;]*m")


def git(*args: str) -> bytes:
    return subprocess.run(["git", *args], cwd=REPO, check=True, capture_output=True).stdout


# --- Rendering ---------------------------------------------------------------


def copy_working_tree(dest: Path) -> None:
    """Copy tracked and untracked (not ignored) files, including uncommitted edits."""
    files = git("ls-files", "-z", "--cached", "--others", "--exclude-standard").split(b"\0")
    for name in filter(None, files):
        src = REPO / name.decode()
        if src.is_file():  # skips files deleted but not yet committed
            target = dest / name.decode()
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, target)


def copy_ref(ref: str, dest: Path) -> None:
    """Extract the committed tree of `ref` (never the working tree)."""
    dest.mkdir(parents=True)
    with tarfile.open(fileobj=io.BytesIO(git("archive", "--format=tar", ref))) as tar:
        tar.extractall(dest, filter="data")


def render_all(root: Path, label: str) -> dict[str, dict]:
    """Render every tests/*/index.qmd plus example.qmd in the copy at `root`."""
    docs = sorted(p.relative_to(root) for p in root.glob("tests/*/index.qmd")) + [Path("example.qmd")]
    results = {}
    for doc in docs:
        name = str(doc.parent if doc.name == "index.qmd" else doc)
        print(f"[{label}] {name}", flush=True)
        proc = subprocess.run(["quarto", "render", str(doc)], cwd=root, capture_output=True, text=True)
        log = ANSI.sub("", proc.stdout + proc.stderr)
        pdf = root / doc.with_suffix(".pdf")
        ok = proc.returncode == 0 and pdf.exists()
        results[name] = {
            "qmd": root / doc,
            "pdf": pdf if ok else None,
            "log": None if ok else log[-2000:],
            "warnings": sorted({m.strip() for m in re.findall(r"(?:warning:|WARN).*", log)}),
        }
    return results


# --- Expectations ------------------------------------------------------------


def check_expectations(qmd: Path, pdf: Path) -> list[str]:
    """Return the expectations from the front matter that the PDF does not meet."""
    match = re.match(r"---\n(.*?)\n---", qmd.read_text(), re.S)
    expect = ((yaml.safe_load(match.group(1)) or {}) if match else {}).get("expect") or {}
    lines = "\n".join(page.get_textpage().get_text_range() for page in pdfium.PdfDocument(pdf))
    text = " ".join(lines.split())  # also turns non-breaking spaces into plain ones
    failures = [f"missing text: {s!r}" for s in expect.get("contains", []) if " ".join(s.split()) not in text]
    failures += [f"unexpected text: {s!r}" for s in expect.get("absent", []) if " ".join(s.split()) in text]
    if expect.get("pairs"):
        for line in lines.splitlines():
            m = re.match(r"•\s*(.+?):\s*(.+?)\s*$", line)
            if m and m.group(1).split() != m.group(2).split():
                failures.append(f"mismatch: {' '.join(line.split())!r}")
    return failures


# --- Page comparison ---------------------------------------------------------


def page_images(pdf: Path | None) -> list[Image.Image]:
    if pdf is None:
        return []
    return [page.render(scale=SCALE).to_pil().convert("RGB") for page in pdfium.PdfDocument(pdf)]


def compare(name: str, old: Path | None, new: Path | None, out: Path) -> list[dict]:
    """Save before/after/diff images of each changed page; return their descriptions."""
    olds, news = page_images(old), page_images(new)
    size = (olds or news)[0].size if (olds or news) else (10, 10)
    changes = []
    for i in range(max(len(olds), len(news))):
        before = olds[i].resize(size) if i < len(olds) else Image.new("RGB", size, "white")
        after = news[i].resize(size) if i < len(news) else Image.new("RGB", size, "white")
        mask = ImageChops.difference(before, after).convert("L").point(lambda v: 255 if v else 0)
        pixels = mask.histogram()[255]
        if pixels == 0 and i < len(olds) and i < len(news):
            continue
        diff = Image.blend(after, Image.new("RGB", size, "white"), 0.75)
        diff.paste(Image.new("RGB", size, (220, 0, 0)), mask=mask)
        stem = f"{name.replace('/', '_')}-p{i + 1}"
        for kind, img in (("before", before), ("after", after), ("diff", diff)):
            img.save(out / f"{stem}-{kind}.png")
        changes.append({"page": i + 1, "pixels": pixels, "stem": stem})
    return changes


# --- Report ------------------------------------------------------------------


def write_report(path: Path, header: str, results: dict[str, dict]) -> None:
    sections, quiet = [], []
    for name, r in results.items():
        if not (r["notes"] or r["failures"] or r["warnings"] or r["log"] or r["changes"]):
            quiet.append(name)
            continue
        items = [f"<li>{html.escape(n)}</li>" for n in r["notes"]]
        items += [f"<li class=fail>{html.escape(f)}</li>" for f in r["failures"]]
        items += [f"<li class=warn>{html.escape(w)}</li>" for w in r["warnings"]]
        log = f"<pre>{html.escape(r['log'])}</pre>" if r["log"] else ""
        pages = "".join(
            f"<h3>Page {c['page']}: {c['pixels']:,} pixels changed</h3><div class=row>"
            + "".join(
                f"<figure><img src='pages/{c['stem']}-{kind}.png'><figcaption>{kind}</figcaption></figure>"
                for kind in ("before", "after", "diff")
            )
            + "</div>"
            for c in r["changes"]
        )
        sections.append(f"<section><h2>{html.escape(name)}</h2><ul>{''.join(items)}</ul>{log}{pages}</section>")
    path.write_text(f"""<!doctype html><meta charset=utf-8><title>Test report</title>
<style>
body {{ font: 15px/1.4 system-ui, sans-serif; margin: 2rem; background: #fff; color: #111 }}
.row {{ display: flex; gap: 1rem; overflow-x: auto }}
figure {{ margin: 0 }} img {{ max-width: 32vw; border: 1px solid #ccc }}
figcaption {{ text-align: center; color: #666 }}
.fail {{ color: #b00 }} .warn {{ color: #666 }}
section {{ border-top: 2px solid #ddd; margin-top: 2rem }}
</style>
<h1>Test report</h1><p>{html.escape(header)}</p>
{''.join(sections) or '<p>All expectations met; no warnings or changes.</p>'}
<p>Nothing to report: {html.escape(', '.join(quiet)) or 'none'}</p>
""")


# --- Main --------------------------------------------------------------------


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--ref", help="git ref to compare against, e.g. main or HEAD")
    args = parser.parse_args()

    run = REPO / "_build" / datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    copy_working_tree(run / "current")
    current = render_all(run / "current", "current")
    baseline = {}
    if args.ref:
        copy_ref(args.ref, run / "baseline")
        baseline = render_all(run / "baseline", args.ref)
        (run / "pages").mkdir()

    quarto = subprocess.run(["quarto", "--version"], capture_output=True, text=True).stdout.strip()
    header = f"Quarto {quarto}, working tree"
    if args.ref:
        header += f" compared with {args.ref} ({git('rev-parse', '--short', args.ref).decode().strip()})"

    results = {}
    for name in sorted(set(current) | set(baseline)):
        cur, base = current.get(name), baseline.get(name)
        r = {"notes": [], "failures": [], "warnings": [], "log": None, "changes": []}
        if cur is None:
            r["notes"].append(f"removed since {args.ref}")
        elif cur["pdf"] is None:
            r["failures"].append("render failed")
            r["log"] = cur["log"]
        else:
            r["failures"] = check_expectations(cur["qmd"], cur["pdf"])
            r["warnings"] = cur["warnings"]
        if args.ref:
            if base is None:
                r["notes"].append(f"new since {args.ref}")
            r["changes"] = compare(name, base and base["pdf"], cur and cur["pdf"], run / "pages")
        results[name] = r

    report = run / "report.html"
    write_report(report, header, results)
    print(f"\n{header}")
    for name, r in results.items():
        for line in r["notes"] + [f"FAIL {f}" for f in r["failures"]] + [f"WARN {w}" for w in r["warnings"]]:
            print(f"{name}: {line}")
        if r["changes"]:
            print(f"{name}: changed pages {', '.join(str(c['page']) for c in r['changes'])}")
    print(f"Report: {report.relative_to(REPO)}")
    return 1 if any(r["failures"] for r in results.values()) else 0


if __name__ == "__main__":
    sys.exit(main())

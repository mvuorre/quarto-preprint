--[[
author-footnote – handle author metadata for docx format

For docx format:
- Place affiliations after date (by appending to date metadata)
- Place equal contributors and correspondence info in a single footnote
]]

local List = require 'pandoc.List'

function Meta(meta)
  if FORMAT ~= 'docx' then
    return meta
  end

  -- Add footnote to author metadata
  if meta.author_footnote and meta.author then
    local footnote = pandoc.Note(meta.author_footnote)
    meta.author = pandoc.MetaInlines(
      List:new(meta.author) .. List:new{footnote}
    )
    meta.author_footnote = nil
  end

  -- Append affiliations to date field so they appear after date, before abstract
  if meta.author_affiliations and meta.date then
    -- Convert date to inlines if it isn't already
    local date_inlines = List:new()
    if meta.date.t == 'MetaInlines' then
      date_inlines = List:new(meta.date)
    else
      date_inlines = List:new{pandoc.Str(pandoc.utils.stringify(meta.date))}
    end

    -- Add line breaks and affiliations
    date_inlines:insert(pandoc.LineBreak())
    date_inlines:insert(pandoc.LineBreak())

    -- Extract inlines from affiliation blocks
    for _, block in ipairs(meta.author_affiliations) do
      if block.t == 'Para' then
        date_inlines:extend(block.content)
        date_inlines:insert(pandoc.LineBreak())
      end
    end

    meta.date = pandoc.MetaInlines(date_inlines)
    meta.author_affiliations = nil
  end

  return meta
end

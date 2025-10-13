--[[
ScholarlyMeta – normalize author/affiliation meta variables

Copyright (c) 2017-2021 Albert Krewinkel, Robert Winkler

Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
THIS SOFTWARE.
]]

local List = require 'pandoc.List'
local utils = require 'pandoc.utils'
local stringify = utils.stringify

local M = {}


-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/scholarly-metadata/scholarly-metadata.lua
--- Returns a function which checks whether an object has the given ID.
local function has_id(id)
  return function(x) return x.id == id end
end


-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/scholarly-metadata/scholarly-metadata.lua
--- Resolve institute placeholders to full named objects
local function resolve_institutes(institute, known_institutes)
  local unresolved_institutes
  if institute == nil then
    unresolved_institutes = {}
  elseif type(institute) == "string" or type(institute) == "number" then
    unresolved_institutes = {institute}
  else
    unresolved_institutes = institute
  end

  local result = List:new{}
  for i, inst in ipairs(unresolved_institutes) do
    -- this has been modified by @kapsner
    --result[i] =
    --  known_institutes[tonumber(inst)] or
    --  known_institutes:find_if(has_id(pandoc.utils.stringify(inst))) or
    --  to_named_object(inst)
    intermed_val = known_institutes:find_if(has_id(stringify(inst)))
    result[i] = pandoc.MetaString(stringify(intermed_val.index))
  end
  return result
end
M.resolve_institutes = resolve_institutes

return M
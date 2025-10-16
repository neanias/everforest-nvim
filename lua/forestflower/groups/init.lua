local M = {}

-- Deterministic ordered modules. Adjust / extend as needed.
local ordered_modules = {
  "base",
  "completion",
  "git",
  "ui",
  "tooling",
  "ai",
}

local function safe_require(name)
  local ok, mod = pcall(require, name)
  if not ok then return nil end
  return mod
end

local function merge(into, from)
  for k, v in pairs(from) do
    into[k] = v
  end
end

---Build merged highlight table from sub-modules.
---@param theme ForestflowerTheme
---@param options Config
function M.build(theme, options)
  local all = {}
  for _, short in ipairs(ordered_modules) do
    local mod = safe_require("forestflower.groups." .. short)
    if mod then
      local tbl = type(mod) == "function" and mod(theme, options) or mod
      if tbl and type(tbl) == "table" then
        merge(all, tbl)
      end
    end
  end
  return all
end

return M

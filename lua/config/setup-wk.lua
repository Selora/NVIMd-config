local wk = require('which-key')
local keymaps = require('config.keymaps').wk

-- local function printTable(tbl, indent)
--   indent = indent or 0
--   for k, v in pairs(tbl) do
--     if type(v) == "table" then
--       print(string.rep(" ", indent) .. k .. ":")
--       printTable(v, indent + 4)
--     else
--       print(string.rep(" ", indent) .. k .. ": " .. tostring(v))
--     end
--   end
-- end

for _, getter in pairs(keymaps) do
  local mapping, opt = unpack(getter())
  -- print("Next:")
  -- printTable(mapping)
  -- printTable(opt)
  wk.register(mapping, opt)
end

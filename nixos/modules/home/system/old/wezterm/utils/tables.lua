local M = {}

M.merge = function(tables)
  local res = {}
  for _, table in pairs(tables) do
      for key, value in pairs(table) do res[key] = value end
  end
  return res
end

return M
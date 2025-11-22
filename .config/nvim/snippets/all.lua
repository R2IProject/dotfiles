local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function capitalize(args)
  local word = args[1][1] or ""
  if word == "" then
    return ""
  end
  return word:sub(1, 1):upper() .. word:sub(2)
end

return {
  s("uses", {
    t("const ["),
    i(1, "state"),
    t(", set"),
    f(function(args)
      return capitalize(args)
    end, { 1 }),
    t("] = useState("),
    i(2, "initial"),
    t(")"),
  }),
}

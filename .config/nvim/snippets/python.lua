local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function model_from_class(args)
  local name = args[1][1] or ""
  return name
end

return {

  -- CharField with blank & null
  s("charfbn", {
    t("models.CharField(max_length="),
    i(1, "255"),
    t(", blank="),
    i(2, "True"),
    t(", null="),
    i(3, "True"),
    t(")"),
  }),

  -- CharField simple
  s("charf", {
    t("models.CharField(max_length="),
    i(1, "255"),
    t(")"),
  }),

  -- IntegerField blank null
  s("intefbn", {
    t("models.IntegerField(blank="),
    i(1, "True"),
    t(", null="),
    i(2, "True"),
    t(")"),
  }),

  -- ModelSerializer
  s("mseri", {
    t("class "),
    i(1, "Name"),
    t("Serializer(serializers.ModelSerializer):"),
    t({ "", "    class Meta:" }),
    t({ "", "        model = models." }),
    f(model_from_class, { 1 }),
    t({ "", '        fields = "__all__"' }),
  }),

  -- Select Serializer
  s("sseri", {
    t("class Select"),
    i(1, "Name"),
    t("Serializer(serializers.ModelSerializer):"),
    t({ "", "    class Meta:" }),
    t({ "", "        model = models." }),
    f(model_from_class, { 1 }),
    t({ "", "        fields = [" }),
    i(2, '"field1", "field2"'),
    t("]"),
  }),

  -- ViewSet
  s("sview", {
    t("class "),
    i(1, "Name"),
    t("ViewSets(viewsets.ModelViewSet):"),
    t({ "", "    queryset = models." }),
    f(model_from_class, { 1 }),
    t(".objects.all().order_by('-created_at')"),
    t({ "", "    serializer_class = serializers." }),
    f(model_from_class, { 1 }),
    t("Serializer"),
  }),

  -- NonPaginatedSelect ViewSet
  s("npsview", {
    t("class NonPaginatedSelect"),
    i(1, "Name"),
    t("ViewSets(viewsets.ModelViewSet):"),
    t({ "", "    queryset = models." }),
    f(model_from_class, { 1 }),
    t(".objects.all().order_by('-created_at')"),
    t({ "", "    serializer_class = serializers.Select" }),
    f(model_from_class, { 1 }),
    t("Serializer"),
  }),
}

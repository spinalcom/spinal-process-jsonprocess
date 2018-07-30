require("spinal-core-connectorjs")
G_root = if typeof window == "undefined" then global else window

module.exports = {
  modelType: G_root.Obj,
  modelName: "Obj",
  prority: 1

  handler: () ->
    @_json.data = @_model._data
    return Promise.resolve(@_json)
}

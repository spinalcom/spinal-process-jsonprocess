require("spinal-core-connectorjs")
Q = require("q")
G_root = if typeof window == "undefined" then global else window

module.exports = {
  modelType: G_root.Lst,
  modelName: "Lst",
  prority: 1
  handler: () ->
    _json = @_json
    _model = @_model
    _json.data = [] if (not _json.data)
    prom = []
    i = 0
    len = _model.length
    while (i < len)
      value = _model[i]
      prom.push(G_root.JsonProcess._assignPush.call(@, _json, value))
      i++
    return Q.all(prom).then( (data) ->
      return _json)
}
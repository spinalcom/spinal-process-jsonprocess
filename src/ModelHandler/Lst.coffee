require("spinal-core-connectorjs")
G_root = if typeof window == "undefined" then global else window

module.exports = {

  ###*
  * [Model] The declaration of the Model
  ###
  modelType: G_root.Lst,

  ###*
  * [String] The constructor name of the Model
  ###
  modelName: "Lst",

  ###*
  * [Number] the defaut handler executed is the one with the highiest priority
  ###
  prority: 1

  ###*
  * [Function] The handler itself return a promise with the _json in the resolve
  ###
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
    return Promise.all(prom).then( (data) ->
      return _json)

  ###*
  * handler to "update" the max_depth of children
  * Optionnal, if  not definied will use the default one (Model / Lst / Ptr)
  ###
  set_children_depth_handler: (_json, new_max_depth) ->
    prom = for child in _json.data
      targetJsonProcess = G_root.JsonProcess._getJsonProcess(child)
      if (targetJsonProcess.max_depth < new_max_depth)
        targetJsonProcess.max_depth = new_max_depth
        targetJsonProcess._is_rdy = targetJsonProcess._update()
      targetJsonProcess._is_rdy

    return Promise.all(prom).then(() ->
      return process._json
    )
}
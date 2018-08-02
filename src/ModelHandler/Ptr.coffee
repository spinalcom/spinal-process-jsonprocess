require("spinal-core-connectorjs")
G_root = if typeof window == "undefined" then global else window

module.exports = {
  modelType: G_root.Ptr,
  modelName: "Ptr",
  prority: 1

  handler: () ->
    _json = @_json
    _model = @_model
    if @_load_ptr == true
      if (_model.data.value == 0)
        _json.data = {
            _server_id: _model.data.value
        }
        return Promise.resolve(_json)
      return ((new Promise((resolve, reject) ->
        _model.load((ptr) ->
          if ptr
            resolve(ptr)
          else
            reject("Load error: " + _model._server_id)
        )
      ))
      .then((m) =>
        return G_root.JsonProcess._assignWithModel.call(@, @_json, "data", m)
      , (error) -> console.error error))
    else
      _json.data = {
          _server_id: _model.data.value
      }
      return Promise.resolve(_json)

  ###*
  * handler to "update" the max_depth of children
  * Optionnal, if  not definied will use the default one (Model / Lst / Ptr)
  * @returns a promise with the _json in the resolve
  ###
  set_children_depth_handler: (_json, new_max_depth) ->
    process = G_root.JsonProcess._getJsonProcess(_json)
    if (process._max_depth < new_max_depth)
      process._max_depth = new_max_depth
      process._is_rdy = process._update()
    return process._is_rdy.then(() ->
      return process._json
    )
}
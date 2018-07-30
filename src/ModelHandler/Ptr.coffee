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
        return Promise.reject()
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
}
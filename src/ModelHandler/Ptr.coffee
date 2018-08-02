require("spinal-core-connectorjs")
G_root = if typeof window == "undefined" then global else window

load_ptr_func = (ptr) ->
  target_ptr = ptr.data.value
  if (target_ptr && typeof FileSystem._objects[target_ptr] != 'undefined')
    return Promise.resolve(FileSystem._objects[target_ptr])
  return new Promise((resolve, reject) ->
    ptr.load((result) ->
      if (result)
        resolve(result)
      else
        reject("Ptr load error target = #{target_ptr}")
    )
  )

module.exports = {
  modelType: G_root.Ptr,
  modelName: "Ptr",
  prority: 1

  handler: () ->
    _json = @_json
    _model = @_model
    if @_load_ptr == true || _model.data.value != 0
      return load_ptr_func(_model)
      .then((m) =>
        return G_root.JsonProcess._assignWithModel.call(@, @_json, "data", m)
      , (error) -> console.error error)
    else
      _json.data = {
          _server_id: _model.data.value
      }
      return Promise.resolve(_json)

}
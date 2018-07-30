require("spinal-core-connectorjs")
G_root = if typeof window == "undefined" then global else window

module.exports = {
  modelType: G_root.Model,
  modelName: "Model",
  prority: 0
  handler: () ->
    _json = @_json
    _model = @_model
    _json.data = {} if (not _json.data)
    for model_key of _json.data
      if  _model._attribute_names.indexOf(model_key)
        delete _json.data[model_key]
    prom = for model_key in _model._attribute_names
      if typeof _json.data[model_key] is 'undefined'
        G_root.JsonProcess._assignWithKey.call(@, _json.data, model_key, _model)
      else if _json.data[model_key]._server_id != _model[model_key]._server_id
        delete _json.data[model_key]
        G_root.JsonProcess._assignWithKey.call(@, _json.data, model_key, _model)
      else
        _json.data[model_key]
    return Promise.all(prom).then((data) ->
      return _json)
}
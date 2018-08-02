require("spinal-core-connectorjs")
G_root = if typeof window == "undefined" then global else window

module.exports = {

  ###*
  * [Model] The declaration of the Model
  ###
  modelType: G_root.Model,

  ###*
  * [String] The constructor name of the Model
  ###
  modelName: "Model",

  ###*
  * [Number] the defaut handler executed is the one with the highiest priority
  ###
  prority: 0

  ###*
  * [Function] The handler itself return a promise with the _json in the resolve
  ###
  handler: () ->
    _json = @_json
    _model = @_model
    _json.data = {} if (not _json.data)
    for model_key of _json.data
      if  _model._attribute_names.indexOf(model_key)
        delete _json.data[model_key]
    prom = for model_key in _model._attribute_names
      G_root.JsonProcess._assignWithKey.call(@, _json.data, model_key, _model)
    return Promise.all(prom).then((data) ->
      return _json)

}
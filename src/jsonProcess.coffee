# Copyright 2015 SpinalCom - www.spinalcom.com
#
# This file is part of SpinalCore.
#
# Please read all of the following terms and conditions
# of the Free Software license Agreement ("Agreement")
# carefully.
#
# This Agreement is a legally binding contract between
# the Licensee (as defined below) and SpinalCom that
# sets forth the terms and conditions that govern your
# use of the Program. By installing and/or using the
# Program, you agree to abide by all the terms and
# conditions stated or referenced herein.
#
# If you do not agree to abide by these terms and
# conditions, do not demonstrate your acceptance and do
# not install or use the Program.
#
# You should have received a copy of the license along
# with this file. If not, see
# <http://resources.spinalcom.com/licenses.pdf>.


G_root = if typeof window == "undefined" then global else window
require("spinal-core-connectorjs")

###*
 * Utility process to create a json like object always synchronized with the SpinalHub server.
 *
 * h3 The Model NEEDS to be synchonized with the spinalhub server.
 *
 * Usage Example:
 *
 * ```sh
 *   npm i --save spinal-process-jsonprocess
 * ```
 *
 * ```js
 * var spinalCore = require("spinal-core-connectorjs");
 *
 * var JsonProcess = require("spinal-process-jsonprocess").JsonProcess;
 * var create_JsonProcess = require("spinal-process-jsonprocess").create_JsonProcess;
 * // or for es6
 * // import { JsonProcess, create_JsonProcess } from "spinal-process-jsonprocess"
 * // or
 * // import create_JsonProcess from "spinal-process-jsonprocess"
 * // import { JsonProcess } from "spinal-process-jsonprocess"
 *
 *
 * const connect_opt = "http://168:JHGgcz45JKilmzknzelf65ddDadggftIO98P@localhost:7777/";
 *
 * var conn = spinalCore.connect(connect_opt);
 * spinalCore.load(conn, "__users__", callback_success);
 *
 * function callback_success(file) {
 *
 *   JsonProcess(file, 3, false)
 *     .then(_process => {
 *       JsonProcess.setOnLocalChange(json, (json) => {
 *         console.log("the model have a local change !", json);
 *       });
 *
 *       // carefull circular Json doesn't
 *       // work with JSON.stringify
 *       console.log(JSON.stringify(_process, null, 2));
 *     })
 *     .catch(console.error);
 *
 * };
 * ```
 * @see to create an JsonProcess instance use
 * `create_JsonProcess` or `create_JsonProcess_by_server_id`
 * @class JsonProcess
###
class G_root.JsonProcess extends G_root.Process
  @_type_handler: []
  @_JsonProcess: []
  @_registerID: 0

  ###*
  * h4 /!\ **Don't use the Contructor directly but use the following static method :**
  * * `create_JsonProcess`
  * * `create_JsonProcess_by_server_id`
  ###
  constructor: (model, max_depth, load_ptr, depth) ->
    super model, false
    @_model = model
    @_depth = depth
    @_max_depth = max_depth
    @_load_ptr = load_ptr
    @_json = {
      _server_id: model._server_id
      _constructor_name: model.constructor.name,
      data: null
    }
    @handler = null
    for handler in G_root.JsonProcess._type_handler
      if (@_model instanceof handler.modelType)
        @handler = handler.handler
        break
    if (@handler == null)
      # it shouldn't happend
      throw new Error("jsonProcess, imposible to find an handle for #{@_model.constructor.name}")

    @_onChange = []
    @_onLocalChange = []
    @_onChildChange = []

    # wait rdy
    @_is_rdy = @_update()

  ###*
  * Static Method to create a JsonProcess
  * @param model [Model] SpinalCore model to follow
  * @param max_depth [Number = null] the max depth default is depth + 2
  * @param load_ptr [Bool = false] to load or not the ptr
  * @param depth [Number = 0] current depth default at 0
  * @returns [Promise] the `_json` attribute is returned when resolved
  ###
  @create_JsonProcess: (model, max_depth = null, load_ptr = false, depth = 0) ->
    depth += 1
    if not max_depth
      max_depth = depth + 2
    # wait model rdy
    return G_root.JsonProcess._wait_model_sync_server(model).then(() ->
      if (typeof G_root.JsonProcess._getJsonProcess(model) is "undefined")
        G_root.JsonProcess._JsonProcess[model._server_id] =
          new G_root.JsonProcess(model, max_depth, load_ptr, depth)
      return G_root.JsonProcess._getJsonProcess(model)._is_rdy
    )

  ###*
  * Static Method to create a JsonProcess
  * @param server_id [Number] SpinalCore model to follow
  * @param max_depth [Number = null] the max depth default is depth + 2
  * @param load_ptr [Bool = false] to load or not the ptr
  * @param depth [Number = 0] current depth default at 0
  * @returns [Promise] the `_json` attribute is returned when resolved
  ###
  @create_JsonProcess_by_server_id: (server_id, max_depth, load_ptr, depth) ->
    G_root.JsonProcess.create_JsonProcess(FileSystem._objects[server_id], _max_depth,
    load_ptr, depth)

  ###*
  * Add a callback to call on Model change (itself and child)
  * @param {Obj} json the Json or a child obtained via create_JsonProcess MUST have a `_server_id`
  * @param {Function} cb the function to be called
  * @returns {Function} call it to unregister the callback
  * @api private
  ###
  @setOnChange: (json, cb) ->
    targetJsonProcess = G_root.JsonProcess._getJsonProcess(json)
    G_root.JsonProcess._registerCallback(targetJsonProcess._onChange, cb)
  ###*
  * Add a callback to call on Model change (itself only)
  * @param {Obj} json the Json or a child obtained via create_JsonProcess MUST have a `_server_id`
  * @param {Function} cb the function to be called
  * @returns {Function} call it to unregister the callback
  ###
  @setOnLocalChange: (json, cb) ->
    targetJsonProcess = G_root.JsonProcess._getJsonProcess(json)
    G_root.JsonProcess._registerCallback(targetJsonProcess._onLocalChange, cb)
  ###*
  * Add a callback to call on Model change (child only)
  * @param {Obj} json the Json or a child obtained via create_JsonProcess MUST have a `_server_id`
  * @param {Function} cb the function to be called
  * @returns {Function} call it to unregister the callback
  ###
  @setOnChildChange: (json, cb) ->
    targetJsonProcess = G_root.JsonProcess._getJsonProcess(json)
    G_root.JsonProcess._registerCallback(targetJsonProcess._onChildChange, cb)

  @_getJsonProcess: (obj) ->
    if obj && obj._server_id
      return G_root.JsonProcess._JsonProcess[model._server_id]
    throw new Error ("_getJsonProcess paramaeter must have a '_server_id' attribute")

  _update: ->
    if (@_max_depth < @_depth)
      return Promise.resolve({
        _server_id: @_json._server_id
        _constructor_name: @_model.constructor.name,
      })
    return @handler.call(@)



  ###*
  * Register a custom handler, check [Lst](/blob/master/src/ModelHandler/Lst.coffee)
  * or [Model](/blob/master/src/ModelHandler/Model.coffee) handler
  * @param {Object} handler the handler
  *
  *```js
  * // example for Obj
  * {
  *   modelType: G_root.Obj, // [Model] The declaration of the Model
  *   modelName: "Obj", // [String] The constructor name of the Model
  *   prority: 1, // [Number] the defaut handler executed is the one with the highiest priority
  *
  *   // [Function] The handler itself return a promise with the _json in the resolve
  *   handler: function() {
  *     this._json.data = this._model._data
  *     return Promise.resolve(this._json)
  *     }
  * }
  *```  ###
  @registerHandler: (handler) ->
    G_root.JsonProcess._type_handler.push(handler)
    G_root.JsonProcess._type_handler.sort(G_root.JsonProcess._register_sort)
  @_register_sort: (a, b) ->
    return b.prority - a.prority

  @_assignWithKey: (_data, model_key, _model) ->
    return G_root.JsonProcess._assignWithModel.call(@, _data, model_key, _model[model_key])
  @_assignWithModel: (_data, model_key, _model) ->
    return G_root.JsonProcess
      .create_JsonProcess(_model, @_max_depth,
      @_load_ptr, @_depth).then(
        (child) ->
          _data[model_key] = child
          return _data
      )

  @_assignPush: (_json, _model) ->
    return G_root.JsonProcess
      .create_JsonProcess(_model, @_max_depth,
      @_load_ptr, @_depth)
      .then(
        (child) ->
          _json.data.push(child)
          return _json
      )

  onchange: ->
    # _update json
    if (@_model.has_been_directly_modified())
        @_update().then(() =>
          G_root.JsonProcess._callbackInArray(@_onLocalChange, @_json)
          G_root.JsonProcess._callbackInArray(@_onChange, @_json)
        )
    else
      G_root.JsonProcess._callbackInArray(@_onChildChange, @_json)
      G_root.JsonProcess._callbackInArray(@_onChange, @_json)

  @_callbackInArray: (arr, json) ->
    for obj in arr
      obj.func(json)

  @_registerCallback: (arr, cb) ->
    obj = {
      id: G_root.JsonProcess._registerID++
      func: cb
    }
    return (() ->
      idx = arr.indexOf(obj)
      if idx != -1
        arr.splice(idx, 1)
    )
  @_wait_model_sync_server_loop: (model, resolve) ->
    if (typeof model._server_id == 'undefined' ||
    typeof FileSystem._tmp_objects[model._server_id] != 'undefined' ||
    typeof FileSystem._objects[model._server_id] == 'undefined')
      setTimeout(
        () -> G_root.JsonProcess._wait_model_sync_server_loop(model, resolve)
      , 200)
    else
      resolve()

  @_wait_model_sync_server: (model) ->
    return new Promise((resolve) ->
      G_root.JsonProcess._wait_model_sync_server_loop(model, resolve)
    )


module.exports = {
  JsonProcess,
  create_JsonProcess: JsonProcess.create_JsonProcess,
  default: JsonProcess.create_JsonProcess
}
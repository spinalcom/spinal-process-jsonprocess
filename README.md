

<!-- Start src/jsonProcess.coffee -->

## JsonProcess

Utility process to create a json like object always synchronized with the SpinalHub server.
### The Model NEEDS to be synchonized with the spinalhub server.

Usage Example:

```sh
  npm i --save spinal-process-jsonprocess
```

```js
var spinalCore = require("spinal-core-connectorjs");

var JsonProcess = require("spinal-process-jsonprocess").JsonProcess;
var create_JsonProcess = require("spinal-process-jsonprocess").create_JsonProcess;
// or for es6
// import { JsonProcess, create_JsonProcess } from "spinal-process-jsonprocess"
// or
// import create_JsonProcess from "spinal-process-jsonprocess"
// import { JsonProcess } from "spinal-process-jsonprocess"

const connect_opt = "http://168:JHGgcz45JKilmzknzelf65ddDadggftIO98P@localhost:7777/";

var conn = spinalCore.connect(connect_opt);
spinalCore.load(conn, "__users__", callback_success);

function callback_success(file) {

  JsonProcess(file, 3, false)
    .then(_process => {
      JsonProcess.setOnLocalChange(json, (json) => {
        console.log("the model have a local change !", json);
      });

      // carefull circular Json doesn't
      // work with JSON.stringify
      console.log(JSON.stringify(_process, null, 2));
    })
    .catch(console.error);

};
```

See: to create an JsonProcess instance use `create_JsonProcess` or `create_JsonProcess_by_server_id`

## JsonProcess()

#### /!\ **Don't use the Contructor directly but use the following static method :**
* `create_JsonProcess`
* `create_JsonProcess_by_server_id`

## create_JsonProcess(model, max_depth, load_ptr, depth)

Static Method to create a JsonProcess

### Params:

* *model* [Model] SpinalCore model to follow
* *max_depth* [Number = null] the max depth default is depth + 2; if -1 All Children are loaded
* *load_ptr* [Bool = false] to load or not the ptr
* *depth* [Number = 0] current depth default at 0

### Return:

* [Promise] the `_json` attribute is returned when resolved

## create_JsonProcess_by_server_id(server_id, max_depth, load_ptr, depth)

Static Method to create a JsonProcess

### Params:

* *server_id* [Number] SpinalCore model to follow
* *max_depth* [Number = null] the max depth default is depth + 2; if -1 All Children are loaded
* *load_ptr* [Bool = false] to load or not the ptr
* *depth* [Number = 0] current depth default at 0

### Return:

* [Promise] the `_json` attribute is returned when resolved

## setOnChange(json, cb)

Add a callback to call on Model change (itself and child)

### Params:

* **Obj** *json* the Json or a child obtained via create_JsonProcess MUST have a `_server_id`
* **Function** *cb* the function to be called

### Return:

* **Function** call it to unregister the callback

## setOnLocalChange(json, cb)

Add a callback to call on Model change (itself only)

### Params:

* **Obj** *json* the Json or a child obtained via create_JsonProcess MUST have a `_server_id`
* **Function** *cb* the function to be called

### Return:

* **Function** call it to unregister the callback

## setOnChildChange(json, cb)

Add a callback to call on Model change (child only)

### Params:

* **Obj** *json* the Json or a child obtained via create_JsonProcess MUST have a `_server_id`
* **Function** *cb* the function to be called

### Return:

* **Function** call it to unregister the callback

## getModel(json)

gets back the real model

### Params:

* **Obj** *json* the Json or a child obtained via create_JsonProcess MUST have a `_server_id`

### Return:

* **Function** call it to unregister the callback

## addDepth(json, new)

add to the max_depth and it's child

### Params:

* **Obj** *json* the Json or a child obtained via create_JsonProcess MUST have a `_server_id`
* **Number** *new* max_dapth to add in children

### Return:

* **Function** call it to unregister the callback

## registerHandler(handler)

Register a custom handler, check [Lst](/src/ModelHandler/Lst.coffee)
or [Model](/src/ModelHandler/Model.coffee) handler

### Params:

* **Object** *handler* the handler 
```js
// example for Obj
{
  modelType: G_root.Obj, // [Model] The declaration of the Model
  modelName: "Obj", // [String] The constructor name of the Model
  prority: 1, // [Number] the defaut handler executed is the one with the highiest priority

  // [Function] The handler itself return a promise with the _json in the resolve
  handler: function() {
    this._json.data = this._model._data
    return Promise.resolve(this._json)
    }
}
```

<!-- End src/jsonProcess.coffee -->


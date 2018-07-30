"use strict";

// Generated by CoffeeScript 2.3.1
(function () {
  var G_root;

  require("spinal-core-connectorjs");

  G_root = typeof window === "undefined" ? global : window;

  module.exports = {
    modelType: G_root.Model,
    modelName: "Model",
    prority: 0,
    handler: function handler() {
      var _json, _model, model_key, prom;
      _json = this._json;
      _model = this._model;
      if (!_json.data) {
        _json.data = {};
      }
      for (model_key in _json.data) {
        if (_model._attribute_names.indexOf(model_key)) {
          delete _json.data[model_key];
        }
      }
      prom = function () {
        var i, len, ref, results;
        ref = _model._attribute_names;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          model_key = ref[i];
          if (typeof _json.data[model_key] === 'undefined') {
            results.push(G_root.JsonProcess._assignWithKey.call(this, _json.data, model_key, _model));
          } else if (_json.data[model_key]._server_id !== _model[model_key]._server_id) {
            delete _json.data[model_key];
            results.push(G_root.JsonProcess._assignWithKey.call(this, _json.data, model_key, _model));
          } else {
            results.push(_json.data[model_key]);
          }
        }
        return results;
      }.call(this);
      return Promise.all(prom).then(function (data) {
        return _json;
      });
    }
  };
}).call(undefined);
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9Nb2RlbEhhbmRsZXIvTW9kZWwuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUFBLENBQUEsWUFBQTtBQUFBLE1BQUEsTUFBQTs7QUFBQSxVQUFBLHlCQUFBOztBQUNBLFdBQVksT0FBQSxNQUFBLEtBQUgsV0FBRyxHQUFILE1BQUcsR0FBOEMsTUFBMUQ7O0FBRUEsU0FBQSxPQUFBLEdBQWlCO0FBQ2YsZUFBVyxPQURJLEtBQUE7QUFFZixlQUZlLE9BQUE7QUFHZixhQUhlLENBQUE7QUFJZixhQUFTLG1CQUFBO0FBQ1AsVUFBQSxLQUFBLEVBQUEsTUFBQSxFQUFBLFNBQUEsRUFBQSxJQUFBO0FBQUEsY0FBUSxLQUFDLEtBQVQ7QUFDQSxlQUFTLEtBQUMsTUFBVjtBQUNBLFVBQW9CLENBQUksTUFBeEIsSUFBQSxFQUFBO0FBQUEsY0FBQSxJQUFBLEdBQUEsRUFBQTs7QUFDQSxXQUFBLFNBQUEsSUFBQSxNQUFBLElBQUEsRUFBQTtBQUNFLFlBQUksT0FBTyxnQkFBUCxDQUFBLE9BQUEsQ0FBSixTQUFJLENBQUosRUFBQTtBQUNFLGlCQUFPLE1BQU0sSUFBTixDQURULFNBQ1MsQ0FBUDs7QUFGSjtBQUdBLGFBQUEsWUFBQTs7QUFBTyxjQUFBLE9BQUEsZ0JBQUE7QUFBQSxrQkFBQSxFQUFBO0FBQUEsYUFBQSxJQUFBLENBQUEsRUFBQSxNQUFBLElBQUEsTUFBQSxFQUFBLElBQUEsR0FBQSxFQUFBLEdBQUEsRUFBQTs7QUFDTCxjQUFHLE9BQU8sTUFBTSxJQUFOLENBQVAsU0FBTyxDQUFQLEtBQUgsV0FBQSxFQUFBO3lCQUNFLE9BQU8sV0FBUCxDQUFtQixjQUFuQixDQUFBLElBQUEsQ0FBQSxJQUFBLEVBQTBDLE1BQTFDLElBQUEsRUFBQSxTQUFBLEVBREYsTUFDRSxDO0FBREYsV0FBQSxNQUVLLElBQUcsTUFBTSxJQUFOLENBQVcsU0FBWCxFQUFBLFVBQUEsS0FBb0MsT0FBTyxTQUFQLEVBQXZDLFVBQUEsRUFBQTtBQUNILG1CQUFPLE1BQU0sSUFBTixDQUFXLFNBQVgsQ0FBUDt5QkFDQSxPQUFPLFdBQVAsQ0FBbUIsY0FBbkIsQ0FBQSxJQUFBLENBQUEsSUFBQSxFQUEwQyxNQUExQyxJQUFBLEVBQUEsU0FBQSxFQUZHLE1BRUgsQztBQUZHLFdBQUEsTUFBQTt5QkFJSCxNQUFNLElBQU4sQ0FKRyxTQUlILEM7O0FBUEc7O09BQVAsQyxJQUFBLEMsSUFBQSxDQUFBO0FBUUEsYUFBTyxRQUFBLEdBQUEsQ0FBQSxJQUFBLEVBQUEsSUFBQSxDQUF1QixVQUFBLElBQUEsRUFBQTtBQUM1QixlQUFPLEtBQVA7QUFESyxPQUFBLENBQVA7QUFmTztBQUpNLEdBQWpCO0NBSEEsRSxJQUFBIiwic291cmNlc0NvbnRlbnQiOlsicmVxdWlyZShcInNwaW5hbC1jb3JlLWNvbm5lY3RvcmpzXCIpXG5HX3Jvb3QgPSBpZiB0eXBlb2Ygd2luZG93ID09IFwidW5kZWZpbmVkXCIgdGhlbiBnbG9iYWwgZWxzZSB3aW5kb3dcblxubW9kdWxlLmV4cG9ydHMgPSB7XG4gIG1vZGVsVHlwZTogR19yb290Lk1vZGVsLFxuICBtb2RlbE5hbWU6IFwiTW9kZWxcIixcbiAgcHJvcml0eTogMFxuICBoYW5kbGVyOiAoKSAtPlxuICAgIF9qc29uID0gQF9qc29uXG4gICAgX21vZGVsID0gQF9tb2RlbFxuICAgIF9qc29uLmRhdGEgPSB7fSBpZiAobm90IF9qc29uLmRhdGEpXG4gICAgZm9yIG1vZGVsX2tleSBvZiBfanNvbi5kYXRhXG4gICAgICBpZiAgX21vZGVsLl9hdHRyaWJ1dGVfbmFtZXMuaW5kZXhPZihtb2RlbF9rZXkpXG4gICAgICAgIGRlbGV0ZSBfanNvbi5kYXRhW21vZGVsX2tleV1cbiAgICBwcm9tID0gZm9yIG1vZGVsX2tleSBpbiBfbW9kZWwuX2F0dHJpYnV0ZV9uYW1lc1xuICAgICAgaWYgdHlwZW9mIF9qc29uLmRhdGFbbW9kZWxfa2V5XSBpcyAndW5kZWZpbmVkJ1xuICAgICAgICBHX3Jvb3QuSnNvblByb2Nlc3MuX2Fzc2lnbldpdGhLZXkuY2FsbChALCBfanNvbi5kYXRhLCBtb2RlbF9rZXksIF9tb2RlbClcbiAgICAgIGVsc2UgaWYgX2pzb24uZGF0YVttb2RlbF9rZXldLl9zZXJ2ZXJfaWQgIT0gX21vZGVsW21vZGVsX2tleV0uX3NlcnZlcl9pZFxuICAgICAgICBkZWxldGUgX2pzb24uZGF0YVttb2RlbF9rZXldXG4gICAgICAgIEdfcm9vdC5Kc29uUHJvY2Vzcy5fYXNzaWduV2l0aEtleS5jYWxsKEAsIF9qc29uLmRhdGEsIG1vZGVsX2tleSwgX21vZGVsKVxuICAgICAgZWxzZVxuICAgICAgICBfanNvbi5kYXRhW21vZGVsX2tleV1cbiAgICByZXR1cm4gUHJvbWlzZS5hbGwocHJvbSkudGhlbigoZGF0YSkgLT5cbiAgICAgIHJldHVybiBfanNvbilcbn0iXSwic291cmNlUm9vdCI6Ii4uLy4uIn0=
//# sourceURL=/home/laurent/share_to_send/modules/spinal-process-jsonprocess/src/ModelHandler/Model.coffee
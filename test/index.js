var spinalCore = require("spinal-core-connectorjs");
var Q = require("q");

var JsonProcess = require("../index").JsonProcess;
var create_JsonProcess = require("../index").create_JsonProcess;

if (!process.env.CLIENT_ID) {
  console.log("default config");
  process.env.SPINAL_USER_ID = "168";
  process.env.SPINAL_PASSWORD = "JHGgcz45JKilmzknzelf65ddDadggftIO98P";
  process.env.SPINALHUB_IP = "localhost";
  process.env.SPINALHUB_PORT = 7777;
}
const connect_opt =
  "http://" +
  process.env.SPINAL_USER_ID +
  ":" +
  process.env.SPINAL_PASSWORD +
  "@" +
  process.env.SPINALHUB_IP +
  ":" +
  process.env.SPINALHUB_PORT +
  "/";

var conn = spinalCore.connect(connect_opt);
var err_connect = function(err) {
  if (!err) console.log("Error Connect.");
  else console.log("Error Connect : " + err);
  process.exit(0);
};
let organType = typeof window === "undefined" ? global : window;
let wait_for_endround = file => {
  let deferred = Q.defer();
  let wait_for_endround_loop = (_file, defer) => {
    if (organType.FileSystem._sig_server === false) {
      setTimeout(() => {
        defer.resolve(wait_for_endround_loop(_file, defer));
      }, 100);
    } else defer.resolve(_file);
    return defer.promise;
  };
  return wait_for_endround_loop(file, deferred);
};

let callback_success = file => {
  wait_for_endround(file).then(() => {
    // console.log(file[0]._ptr);
    create_JsonProcess(file, 2, true)
      .then(json => {
        // console.log("-** TEST **-", _process);

        JsonProcess.setOnLocalChange(json, () => {
          console.log("the model had a change !");
        });

        console.log(JSON.stringify(json, null, 2));
        return JsonProcess.addDepth(json.data[1], 3).then(local_change_json => {
          // local_change_json == json.data[1]
          console.log("=====================================================");
          console.log(JSON.stringify(json, null, 2));
        });
      })
      .catch(console.error);
  });
};
spinalCore.load(conn, "__users__", callback_success, err_connect);

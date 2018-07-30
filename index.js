var JsonProcess = require("./lib/jsonProcess");
JsonProcess.JsonProcess.registerHandler(require("./lib/ModelHandler/Model"));
JsonProcess.JsonProcess.registerHandler(require("./lib/ModelHandler/Lst"));
JsonProcess.JsonProcess.registerHandler(require("./lib/ModelHandler/Obj"));
JsonProcess.JsonProcess.registerHandler(require("./lib/ModelHandler/Ptr"));
module.exports = JsonProcess;

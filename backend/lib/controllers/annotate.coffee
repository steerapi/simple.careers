'use strict';

express = require "express"
path = require "path"

annotate = express()

config = require("../config/config")
annotate.use(express.basicAuth(config.annotate.username, config.annotate.password));
annotate.use(express.static(path.resolve(__dirname+'/../../../annotate/dist')));
annotate.use(express.logger());
annotate.use(express.cookieParser());
annotate.use(express.bodyParser());
annotate.use(express.methodOverride());

module.exports = annotate
'use strict';

express = require "express"
path = require "path"

annotate = express()

annotate.use(express.basicAuth('simple', 'simple1337'));
annotate.use(express.static(path.resolve(__dirname+'/../../../annotate/dist')));
annotate.use(express.logger());
annotate.use(express.cookieParser());
annotate.use(express.bodyParser());
annotate.use(express.methodOverride());

module.exports = annotate
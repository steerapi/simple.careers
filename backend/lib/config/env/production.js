'use strict';

module.exports = {
  env: 'production',
  mongo: {
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL ||
         'mongodb://joyce:joyce1331@ds035897.mongolab.com:35897/heroku_app23575007'
  },
  mandrill: "ye5nIk8NpIB6-4g7_WIGhg"
};

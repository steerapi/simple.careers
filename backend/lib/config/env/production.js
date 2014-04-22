'use strict';

module.exports = {
  env: 'production',
  mongo: {
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL ||
         "mongodb://heroku_app23575007:8drgvlro2sa85fall3pul9268u@ds039429-a0.mongolab.com:39429/heroku_app23575007"
  },
  mandrill: "ye5nIk8NpIB6-4g7_WIGhg",
  annotate: {
    username: "simple",
    password: "simple1337"
  }
};

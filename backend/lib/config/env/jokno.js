'use strict';

module.exports = {
  env: 'production',
  mongo: {
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL
  },
  annotate: {
    usernmae: "jokno",
    password: "joknopass"
  }
};

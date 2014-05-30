'use strict';

module.exports = {
  env: 'msutherland',
  mongo: {
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL ||
         'mongodb://localhost/fullstack'
  },
  mandrill: "ye5nIk8NpIB6-4g7_WIGhg",
  annotate: {
    username: "msutherland",
    password: "msutherlandpass"
  },
  name: "Marsh Sutherland",
  email: "msutherland@waldenrecruiting.com"
};

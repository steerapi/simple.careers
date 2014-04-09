#!/bin/sh

grunt build
git add .
git add . -u
git commit -m "update"
git push heroku master
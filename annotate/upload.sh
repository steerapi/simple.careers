#!/bin/sh

grunt build
git add .
git add . -u
git add --all .
git commit -m "update"
git push heroku master
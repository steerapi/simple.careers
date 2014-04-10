#!/bin/sh

cd frontend
grunt build
cd ..
git add .
git add . -u
git commit -m "update"
git push heroku master
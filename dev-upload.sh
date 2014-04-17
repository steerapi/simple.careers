#!/bin/sh

cd frontend
grunt build
cd ..
git add .
git add . -u
git add --all .
git commit -m "update"
git push dev master
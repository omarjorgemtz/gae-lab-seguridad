#!/bin/sh
git checkout master
git pull
git config --global user.name "autoversioner"
git config --global user.email "git@gnp.com.mx"
# Convierte la URL de HTTP parametrizada en una URL de ssh
export SSH_PUSH_REPO=`echo $CI_REPOSITORY_URL | perl -pe 's#.*@(.+?(\:\d+)?)/#git@\1:#'`
git remote set-url --push origin "$SSH_PUSH_REPO"
npm i --no-save update-json-file shelljs cz-conventional-changelog standard-version
npm run autoversion
git push --follow-tags origin master
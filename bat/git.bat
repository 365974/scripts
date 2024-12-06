git config --global user.name "gitname"
git config --global user.email "user@mail.com"
git init
git remote add origin git@github.com:gitname/reponame.git

git fetch origin
git pull origin master

@REM rmdir /s /q .git
@REM git add .
@REM git commit -m "commit"
@REM git push -u origin master
@REM git remote -v
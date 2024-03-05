#!/bin/sh

# Custom aliases

alias killme=killOnPort
alias portlookup="lsof -t -i:3000"
alias stash='git stash'
alias unstash='git stash pop'
alias gdiff='git diff'
alias gpass='git config --global credential.helper osxkeychain'
alias gprune='git fetch --prune origin && git '
alias gsearch=searchGitLogs
alias gdel=removeBranchesWithPrefix
alias glist='git branch -r --merged develop | grep -E "(story|task[s]?|bugfix|feature|project|release)"'
alias pulldx=refreshDXRepos
alias mi=miGoto
alias nocors='open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'
alias server='http-server --ssl --cert ~/workspace/hilton/dx/cert.pem --key ~/workspace/hilton/dx/cert.key'
alias dxk='docker rm -f $(docker ps -a -fname=dx* -q)'
alias dxrmi='docker rmi -f $(docker images | grep "^<none>" | awk "{print $3}")'
alias dxnuke='docker rm -f $(docker ps -a -q) && docker rmi -f $(docker images -q)'
alias dxs='docker-compose -f dx-docker/compose/pot-nodejs-develop.yml up --build'
alias hist='history | grep $1'
alias gremove='git rebase -r --onto $1^ $1'
alias aem='cd ~/workspace/marriott/aem-sdk/aem && java -Xmx2048M -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=30303 -jar aem-author-p4502.jar -gui -r"author,localdev"' 
alias mtu='ping -g 1350 -G 1520 -h 10 -D $1'

# Additional Path Settings

export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export VOLTA="$HOME/.volta"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$VOLTA/bin"

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# Custom Functions

killOnPort() {
  PID=$(lsof -ti :$1);
  if [ -z "$PID" ]
  then
      echo No process running on port "$1";
  else
      echo killing process "$PID" on port "$1";
      kill -9 "$PID";
  fi
}

miGoto() {
  if [ "$1" -eq '' ]; then
    echo "Heading over to funky town!"
  else
    echo "Heading over to $1 town!"
  fi

  cd ~/workspace/marriott/$1

}

refreshDXRepos() {
  for i in `ls -d dx*`;
    do echo "----> $i";
    cd $i;
    git checkout develop;
    git pull;
    cd - > /dev/null 2>&1;
  done
}

removeBranchesWithPrefix() {
  git for-each-ref --format="%(refname:short)" refs/heads/$1\* | xargs git branch -d
}

searchGitLogs() {
  TIMES="25"
  if [ ! -z "$2" ]
  then
    TIMES=$2
  fi
  git log | grep -B 1 -A 3 -m $TIMES $1
}

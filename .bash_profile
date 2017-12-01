# BASH PROFILE | BEGIN


# COLORS | BEGIN
BOLD="\[\033[1m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
STEELBLUE="\[\033[38;5;81m\]"
OFF="\[\033[m\]"
# COLORS | END

# NICE-TO-HAVE ESCAPE SEQUENCES | BEGIN
HOST="\h"
USER="\u"
DIR="\w"
NEWLINE="\n"
DATE="\d"
TIME="\t"
# NICE-TO-HAVE ESCAPE SEQUENCES | END


# PARSE TO PROMPT METHODS | BEGIN

# GIT BRANCH IN PROMPT | BEGIN
is_git_repository () {
  git branch > /dev/null 2>&1
}
set_git_branch () {
  BRANCH="(`parse_git_branch`)"
}
parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}
parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]
}
# GIT BRANCH IN PROMPT | END

# VIRTUALENV IN PROMPT | BEGIN
set_virtualenv () {
   if test -z "$VIRTUAL_ENV" ; then
       PYTHON_VIRTUALENV=""
   else
       PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${OFF}"
   fi
 }
# ACTIVATE VIRTUALENV IN PROMPT | END

# PARSE TO PROMPT METHODS | END

# METHOD TO SET PROMPT | BEGIN
set_bash_prompt () {

    EXITSTATUS="$?"

    #SET PYTHON_VIRTUALENV VARIABLE
    set_virtualenv

    # SET GIT BRANCH VARIABLE
   if is_git_repository ; then
     set_git_branch
   else
     BRANCH=''
   fi

    PROMPT="\[\033]0;${USER}@${HOST}: \w\007\n${STEELBLUE}${TIME} ${DATE} [${USER}]:[${BLUE}\w${RED}]"

    if [ "${EXITSTATUS}" -eq 0 ]
    then
        PS1="${PROMPT} [${GREEN}${EXITSTATUS}${RED}]${OFF} ${PYTHON_VIRTUALENV} ${BRANCH}\n$ "
    else
        PS1="${PROMPT} [${BOLD}${EXITSTATUS}${RED}]${OFF} ${PYTHON_VIRTUALENV} ${BRANCH}\n$ "
    fi

    PS2="${BOLD}>${OFF} "
}
PROMPT_COMMAND=set_bash_prompt
# METHOD TO SET PROMPT | END


# ALIASES | BEGIN

# GIT ALIASES | BEGIN
alias gc="git commit -m"
alias gp="git pull"
alias gs="git status"
alias gpush="git push"
alias ga="git add ."
alias gA="git add -A"
# GIT ALIASES | END

# MAKE NEW <SOMETHING> | BEGIN
alias mkdir="mkdir -pv"
# MAKE NEW <SOMETHING> | END

# DIRECTORY NAVIGATION | BEGIN
alias gtfg="cd $HOME/Programming/fg"
alias gtfga="cd $HOME/Programming/fg/src/angular_frontend"
dir () {
  cd $HOME/Programming/$1
}
# DIRECTORY NAVIGATION | END

# LIST DIRECTORIES | BEGIN
alias ls="ls -FG"
alias ll="ls -lFGh"
alias la="ls -alFGh"
# LIST DIRECTORIES | END

# LIST COMMAND HISTORY | BEGIN
alias histg="history | grep"
# LIST COMMAND HISTORY | END

# PYTHON | BEGIN
alias python2="python"
alias python="python3"
# PYTHON | END

# PIP | BEGIN
alias pip2="pip"
alias pip="pip3"
# PIP | END

# DJANGO ALIASES | BEGIN
alias mig="python manage.py migrate"
alias makemig="python manage.py makemigrations"
alias serve="python manage.py runserver"
# DJANGO ALIASES | END

# ANGULAR | BEGIN
alias build="ng build --watch"
# ANGULAR | END

# ANACONDA | BEGIN
alias defcondaa="$HOME/anaconda/bin/activate"
alias defcondad="$HOME/anaconda/bin/deactivate"
# ANACONDA | END

# VIRTUALENVIRONMENT | BEGIN
venv () {
  virtualenv -p python3 $HOME/Programming/Virtual_Environments/$1
}
venv2() {
  virtualenv $HOME/Programming/Virtual_Environments/$1
}
start_venv () {
  source $HOME/Programming/Virtual_Environments/$1/bin/activate
}
stop_venv () {
  if test -z "$VIRTUAL_ENV" ; then
    echo "No virtual environment active"
  else
    ENV=$VIRTUAL_ENV
    echo "Deactivating virtual environment $VIRTUAL_ENV ..."
      deactivate
    if test -z "$VIRTUAL_ENV"; then
      echo "$ENV Deactivated!"
    else
      echo "\n${RED}Something went wrong, $ENV not deactivated${OFF}"
    fi
  fi
}
# VIRTUALENVIRONMENT | END

# PRINT PUBLIC IP ADDRESS TO CONSOLE | BEGIN
alias myip="curl http://ipecho.net/plain; echo"
# PRINT PUBLIC IP ADDRESS TO CONSOLE | END

# ALIASES | END

# DECOMPRESS MOST FILETYPES | BEGIN
extract () {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}
# DECOMPRESS MOST FILETYPES | END

# BASH PROFILE | END
export PATH="/usr/local/sbin:$PATH"

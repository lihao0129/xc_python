# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# frequently used aliases and functions
alias 4='vim ~/.bashrc'
alias 5='. ~/.bashrc'
alias 6='vim /etc/hosts'
alias l.='ls -d .*'
alias la='ls -A'
alias ll='ls -l'
alias lt='ls -trgA'
alias vi='vim'
alias cdpp='cd /usr/local/lib/python3.6/site-packages'
alias cde='cd /shared/python3/example'

# function to check if host:port is open
n1() { nc -w1 ${2:-localhost} ${1:?"Usage: n1 port host"} </dev/null >/dev/null 2>&1 && echo "success($?)" || echo "failure($?)"; }

export PYTHONPATH=/shared/python3/modules:$PYTHONPATH

# setup JAVA_HOME
#javac=$(readlink -e `which javac`) && export JAVA_HOME=${javac%/*/*}

export SPARK_HOME=/data/spark
export PATH=$SPARK_HOME/bin:$PATH
export PYSPARK_DRIVER_PYTHON=ipython
#export PYSPARK_DRIVER_PYTHON=jupyter
#export PYSPARK_DRIVER_PYTHON_OPTS=notebook

[[ -f ~/.xauthrc ]] && . ~/.xauthrc

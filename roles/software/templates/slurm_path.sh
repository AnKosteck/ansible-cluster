if [ -z $PATH ]; then
  PATH={{slurminfo['prefix']}}/bin
else
  PATH={{slurminfo['prefix']}}/bin:$PATH
fi

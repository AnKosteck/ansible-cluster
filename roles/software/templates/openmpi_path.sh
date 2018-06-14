if [ -z $PATH ]; then
  PATH={{openmpiinfo['prefix']}}/bin
else
  PATH={{openmpiinfo['prefix']}}/bin:$PATH
fi

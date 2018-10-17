#!/bin/bash

LOG={{build_anchors}}/slurmbuild.log

echo "Install slurm"                         >  $LOG
date                                         >> $LOG

cd {{source_download_dir}}                   >> $LOG
tar xf {{slurminfo['filename']}}             >> $LOG
cd {{slurminfo['extracted_filename']}}       >> $LOG

./configure --prefix={{slurminfo['prefix']}} --sysconfdir={{slurminfo['sysconfdir']}} --localstatedir={{slurminfo['statedir']}} --runstatedir={{slurminfo['statedir']}} 2>1 >> $LOG
make -j {{ansible_processor_vcpus}}                            2>1 >> $LOG
make check                                                     2>1 >> $LOG
make install                                                   2>1 >> $LOG

cd ..
rm -rf {{slurminfo['extracted_filename']}}

#!/bin/bash

LOG={{build_anchors}}/slurmbuild.log

echo "Install slurm"                         >  $LOG
date                                         >> $LOG

cd {{source_download_dir}}                   >> $LOG
tar xf {{slurminfo['filename']}}             >> $LOG
cd {{slurminfo['extracted_filename']}}       >> $LOG

./configure --prefix={{slurminfo['prefix']}} --sysconfdir={{slurminfo['sysconfdir']}} --localstatedir={{slurminfo['statedir']}} --runstatedir={{slurminfo['statedir']}} 2>1 >> $LOG
make                                                           2>1 >> $LOG
make check                                                     2>1 >> $LOG
make install                                                   2>1 >> $LOG

{% if 'frontend' in group_names %}
cp etc/slurmctld.service /usr/lib/systemd/system/              2>1 >> $LOG
cp etc/slurmdbd.service /usr/lib/systemd/system/               2>1 >> $LOG
{% else %}
cp etc/slurmd.service /usr/lib/systemd/system/                 2>1 >> $LOG
{% endif %}
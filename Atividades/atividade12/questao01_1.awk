awk '$5 !~ /sshd,*/ { print }' auth.log.1

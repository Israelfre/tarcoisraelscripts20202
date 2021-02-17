awk '$5 ~ /sshd,*/ && $6 ~ /Disconnected.*/ && $10 ~ /root.*/ { print }' auth.log.1 

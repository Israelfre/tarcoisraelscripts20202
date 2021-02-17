awk '$5 ~ /sshd,*/ && $6 ~ /Accepted/ { print }' auth.log.1 

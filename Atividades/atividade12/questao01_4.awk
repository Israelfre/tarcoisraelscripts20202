# Não está funcionando
awk '$1 ~ /Dec/ && $2 == 4 && $3 >= "18:00:00" && $3 <= "19:00:00" && $5 ~ /sshd.*/ && $6 ~ /Accepted.*/ { print }' 

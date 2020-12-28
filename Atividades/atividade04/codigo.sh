#!/bin/bash
# Correção: 0,6

sed -i 's/\/bin\/python/\/usr\/\bin\/\python3/g' atividade04.py

# notaFinal não vira NOTAFINAL
sed -i 's/nota/\U&/g' atividade04.py

sed -i '4s/$/import time/' atividade04.py

# Não é um comando sed
echo "print(time.ctime())" >> atividade04.py 



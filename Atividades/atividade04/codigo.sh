#!/bin/bash

sed -i 's/\/bin\/python/\/usr\/\bin\/\python3/g' atividade04.py

sed -i 's/nota/\U&/g' atividade04.py

sed -i '4s/$/import time/' atividade04.py

echo "print(time.ctime())" >> atividade04.py 



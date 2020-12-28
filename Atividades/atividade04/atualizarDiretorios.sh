#!/bin/bash
# Correção: 1,0

cp /etc/passwd passwd.new

sed -i 's/\/home\/alunos/\/srv\/\students/g' passwd.new 


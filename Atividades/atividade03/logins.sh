#!/bin/bash
# Correção: 0,8
# Qual arquivo os comandos estão executando sobre?
grep -v 'sshd'

grep -E 'sshd[[[:digit:]]*]:[[:space:]]*Accepted'

grep -E 'sshd.*root'  

grep -E 'Dec[[:space:]]*4.*Accepted' 


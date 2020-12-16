#!/bin/bash
# Correção: OK. Não é preciso utilizar o >> se você já usa o tee.
echo "Olá $(whoami), Hoje é dia $(date +%d), do mês $(date +%B), do ano $(date +%G)." | tee -a >> saudacao.log




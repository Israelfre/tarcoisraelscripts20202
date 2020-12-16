 #!/bin/bash

echo "Olá $(whoami), Hoje é dia $(date +%d), do mês $(date +%B), do ano $(date +%G)." | tee -a >> saudacao.log




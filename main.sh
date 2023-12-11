#!/bin/bash

# Importação dos scripts
source ./scripts/verifica_requisitos.sh
source ./scripts/aplica_configuracoes.sh
source ./scripts/valida_configuracoes.sh

# Mapeia os IPs do arquivo servidores.txt pra dentro da variável servidores
mapfile -t servidores < servidores.txt

# Definição do comando SSH
SSH="ssh -o BatchMode=yes -o NumberOfPasswordPrompts=1 -o ConnectTimeout=5 -n"

executa_scripts() {
  verifica_requisitos
  aplica_configuracoes
  valida_configuracoes
}

# Loop para conectar via SSH nas máquinas e executar a função
for IP in "${servidores[@]}"
do
  echo -e "\n$IP..."

  $SSH $IP "$(typeset -f); executa_scripts $IP" 2>/dev/null

  if [ $? -ne 0 ]; then
    echo "Erro ao estabelecer conexão SSH com o IP: $IP"
  fi

  sleep 1
done

echo -e "\nVarredura terminada :)"

exit

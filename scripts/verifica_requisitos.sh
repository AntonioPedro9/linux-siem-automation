#!/bin/bash

verifica_requisitos() {
  falha=0

  # Verifica se o audit está instalado
  if ! command -v auditd &> /dev/null; then
    echo "Erro: Máquina sem o serviço audit"
    falha=1
  fi

  # Verifica se o rsyslog está instalado
  if ! command -v rsyslog &> /dev/null; then
    echo "Erro: Máquina sem o serviço rsyslog"
    falha=1
  fi

  # Verifica se o diretório audisp ou audit existe
  if [ ! -d "/etc/audisp/plugins.d" ] && [ ! -d /etc/audit/plugins.d ]; then
    echo "Erro: Máquina sem diretório audisp e audit"
    falha=1
  fi

  # Verifica se o arquivo rsyslog.conf existe
  if [ -f "/etc/rsyslog.conf" ]; then
    echo "Erro: Máquina sem arquivo rsyslog.conf"
    falha=1
  fi

  # Caso algum dos casos falhar a execução é cancelada
  if [ $falha -eq 1 ]; then
    exit 1
  fi
}
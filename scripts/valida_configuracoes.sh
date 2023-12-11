valida_configuracoes() {
  # Verifica se as alterações foram feitas no diretório audisp
  if [ -d "/etc/audisp/plugins.d" ]; then
    grep "active[[:space:]]*=[[:space:]]*yes" /etc/audisp/plugins.d/syslog.conf \
    && echo "[X] active=yes em syslog.conf" \
    || echo "[ ] active=yes em syslog.conf"

    grep "active[[:space:]]*=[[:space:]]*yes" /etc/audisp/plugins.d/af_unix.conf \
    && echo "[X] active=yes em af_unix.conf" \
    || echo "[ ] active=yes em af_unix.conf"
  fi
  
  # Verifica se as alterações foram feitas no diretório audit
  if [ -f "/etc/audit/plugins.d/af_unix.conf" ]; then
    grep "active[[:space:]]*=[[:space:]]*yes" /etc/audit/plugins.d/af_unix.conf \
    && echo "[X] active=yes em af_unix.conf" \
    || echo "[ ] active=yes em af_unix.conf"
  fi

  # Verifica se as alterações foram feitas no arquivo rsyslog.conf
  grep "# Configurações SIEM" /etc/rsyslog.conf \
  && echo "[X] configurações definidas em rsyslog.conf" \
  || echo "[ ] configurações definidas em rsyslog.conf"

  # Reinicia serviços audit e rsyslog
  # Usa service ou systemctl dependendo do sistema
  if command -v service > /dev/null; then
    service auditd restart &> /dev/null && echo "[X] serviço audit reiniciado" || echo "[ ] serviço audit reiniciado"
    service rsyslog restart &> /dev/null && echo "[X] serviço rsyslog reiniciado" || echo "[ ] serviço rsyslog reiniciado"
  else
    systemctl restart auditd &> /dev/null && echo "[X] serviço audit reiniciado" || echo "[ ] serviço audit reiniciado"
    systemctl restart rsyslog &> /dev/null && echo "[X] serviço rsyslog reiniciado" || echo "[ ] serviço rsyslog reiniciado"
  fi

  # Verifica o status dos serviços audit e rsyslog
  # Usa service ou systemctl dependendo do sistema
  if command -v service > /dev/null; then
    service auditd status &> /dev/null && echo "[X] serviço audit em execução" || echo "[ ] serviço audit em execução"
    service rsyslog status &> /dev/null && echo "[X] serviço rsyslog em execução" || echo "[ ] serviço rsyslog em execução"
  else
    systemctl is-active --quiet auditd && echo "[X] serviço audit em execução" || echo "[ ] serviço audit em execução"
    systemctl is-active --quiet rsyslog && echo "[X] serviço rsyslog em execução" || echo "[ ] serviço rsyslog em execução"
  fi
}
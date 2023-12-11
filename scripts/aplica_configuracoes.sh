aplica_configuracoes() {
  # Define active=yes nos arquivos do audit
  if [ -d "/etc/audisp/plugins.d" ]; then
    sed -i "s/^active[[:space:]]*=.*/active=yes/" /etc/audisp/plugins.d/syslog.conf
	sed -i "s/^active[[:space:]]*=.*/active=yes/" /etc/audisp/plugins.d/af_unix.conf
  fi

  if [ -f "/etc/audit/plugins.d/af_unix" ]; then
	sed -i "s/^active[[:space:]]*=.*/active=yes/" /etc/audit/plugins.d/af_unix.conf
  fi

  # Adiciona as configurações de log em rsyslog.conf caso não ainda não tenha
  if ! grep -q "# Configurações SIEM" /etc/rsyslog.conf; then
    cat <<EOT >> /etc/rsyslog.conf

      # Configurações SIEM
	  \$ModLoad imfile
	  \$InputFileName /var/log/audit/audit.log
	  \$InputFileName /var/log/secure
	  \$InputFileTag accesslog
	  \$InputFileStateFile accesslog
	  \$InputFileSeverity error
	  \$InputFileFacility local6
	  \$InputRunFileMonitor
	  \$InputFilePollInterval 10
	  local6.* @192.168.0.4:520 # IP destino
EOT
  fi
}
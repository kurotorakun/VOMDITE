global:
  scrape_interval:     30s
  evaluation_interval: 30s
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093 # Disabled currently

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:
  - job_name: 'prometheus'                  # Prometheus Instances
    static_configs:
    - targets: ['localhost:9090']           # Local Prometheus Monitoring
  - job_name: 'node'                        # Node Exporter Monitoring
    static_configs:
    - targets: [                            # Include itself "prometheus-node" and
            'prometheus-node:9100',         # the list of services to monitor (SRVxxx and LB001)
            '${VMNETWORKCIDR}.${ANSADDRESS}:9100',
            '${VMNETWORKCIDR}.${UPADDRESS}:9100',
%{ for app_srv in APPSERVERS ~}
            '${APPSERVICEAZ0CIDR}.${app_srv.name}:9100',
            '${APPSERVICEAZ1CIDR}.${app_srv.name}:9100',
%{ endfor ~}
            '${DCUPLINKCIDR}.${BALADDRESS}:9100',
            ]
  - job_name: 'snmp'                        # SNMP Exporter Monitoring
    scrape_interval: 10s
    scrape_timeout: 10s
    static_configs:
      - targets:                            # List of SNMP devices (CHR routers)
        - ${WAN1UPLINKCIDR}.1
        - ${WAN1UPLINKCIDR}.2
        - ${WAN1UPLINKCIDR}.253
        - ${WAN1UPLINKCIDR}.254
    metrics_path: /snmp
    params:
      module: [mikrotik]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: ${VMNETWORKCIDR}.${MONADDRESS}:9116    # The SNMP exporter's real hostname:port.

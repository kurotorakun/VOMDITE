#cloud-config

write_files:
  - path: /docker_data/prometheus/data/prometheus.yml
    encoding: b64
    content: ${PROMETHEUSYML}
    permissions: "0644"

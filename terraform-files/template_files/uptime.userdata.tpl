#cloud-config

write_files:
  - path: /docker_data/uptime/data/kuma.db
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${KUMADB}
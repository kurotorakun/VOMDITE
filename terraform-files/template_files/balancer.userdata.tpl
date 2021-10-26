#cloud-config

write_files:
  - path: /docker_data/balancer/nginx.conf
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${NGINXCONF}

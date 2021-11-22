#cloud-config

write_files:
  - path: /guest_tools/test_application.sh
    encoding: b64
    permissions: "0755"
    owner: root:root
    content: ${TESTAPPSH}

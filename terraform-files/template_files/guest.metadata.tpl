#cloud-config

instance-id: ${HOSTNAME}
local-hostname: ${HOSTNAME}

public-keys: 
  - ${HOSTPUBKEY}
  - ${ANSIBLEPUBKEY}

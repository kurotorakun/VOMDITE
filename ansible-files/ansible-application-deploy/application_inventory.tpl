---

docker_hosts:
  hosts:
%{ for app_srv in APPSERVERS ~}
    docker_host0${app_srv.name}:
      ansible_host: ${APPSERVICEAZ0CIDR}.${app_srv.name}
      ansible_user: ${LINUXUSER}
%{ endfor ~}
%{ for app_srv in APPSERVERS ~}
    docker_host1${app_srv.name}:
      ansible_host: ${APPSERVICEAZ1CIDR}.${app_srv.name}
      ansible_user: ${LINUXUSER}
%{ endfor ~}
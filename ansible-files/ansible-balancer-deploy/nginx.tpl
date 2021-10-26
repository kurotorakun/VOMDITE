events {}

http {
  upstream loadbalancer {
%{ for app_srv in APPSERVERS ~}
    server ${APPSERVICEAZ0CIDR}.${app_srv.name}:80 ;
    server ${APPSERVICEAZ0CIDR}.${app_srv.name}:81 ;
%{ endfor ~}    
%{ for app_srv in APPSERVERS ~}
    server ${APPSERVICEAZ1CIDR}.${app_srv.name}:80 ;
    server ${APPSERVICEAZ1CIDR}.${app_srv.name}:81 ;
%{ endfor ~}    
  }

  server {
    location / {
      proxy_pass http://loadbalancer;
    }
  }
}

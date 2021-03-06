---

- hosts: all
  become: true

  tasks:
    - name: Install required system packages
      apt: name={{ item }} state=latest update_cache=yes
      loop: [ 'curl', 'python3-pip', 'virtualenv', 'python3-setuptools' ]

    - name: Add Docker GPG apt Key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker Repository
      apt_repository:
        repo: deb https://download.docker.com/linux/ubuntu focal stable
        state: present

    - name: Update apt and install docker-ce
      apt: update_cache=yes name=docker-ce state=latest

    - name: Install Docker Module for Python
      pip:
        name: docker

    - name: Pull Docker images
      docker_image:
        name: "{{ item }}"
        source: pull
      with_items: 
        - quay.io/prometheus/node-exporter:latest
        - quay.io/prometheus/snmp-exporter:latest
        - quay.io/prometheus/blackbox-exporter:latest
        - pryorda/vmware_exporter
        - quay.io/prometheus/prometheus
        - grafana/grafana-oss

    # Generate monitoring network
    - name: Generate Docker Monitoring Network
      docker_network:
        name: monitoring_net

    - name: Create Prometheus Node Exporter container
      docker_container:
        name: "prometheus-node"
        image: "quay.io/prometheus/node-exporter:latest"
        detach: yes
        networks:
          - name: "monitoring_net"
        ports:
          - "9100:9100"
        volumes:
          - "/:/host:ro,rslave"
        state: started
        restart_policy: unless-stopped
    
    - name: Create Prometheus SNMP Exporter container
      docker_container:
        name: "prometheus-snmp"
        image: "quay.io/prometheus/snmp-exporter:latest"
        detach: yes
        networks:
          - name: "monitoring_net"
        ports:
          - "9116:9116"
        state: started
        restart_policy: unless-stopped
    
    - name: Create Prometheus Blackbox Exporter container
      docker_container:
        name: "prometheus-blackbox"
        image: "quay.io/prometheus/blackbox-exporter:latest"
        detach: yes
        networks:
          - name: "monitoring_net"
        ports:
          - "9115:9115"
        state: started
        restart_policy: unless-stopped

    - name: Create Prometheus ESXi Exporter container
      docker_container:
        name: "prometheus-esxi"
        image: "pryorda/vmware_exporter"
        detach: yes
        networks:
          - name: "monitoring_net"
        ports:
          - "9272:9272"
        env:
          VSPHERE_USER: "${ESXIUSER}"
          VSPHERE_PASSWORD: "${ESXIPASS}"
          VSPHERE_HOST: "${ESXIHOST}"
          VSPHERE_IGNORE_SSL: "True" 
          VSPHERE_SPECS_SIZE: "2000"
        state: started
        restart_policy: unless-stopped
    
    - name: Create Prometheus container
      docker_container:
        name: "prometheus-server"
        image: "quay.io/prometheus/prometheus:latest"
        detach: yes
        networks:
          - name: "monitoring_net"
        ports:
          - "9090:9090"
        volumes:
          - "/docker_data/prometheus/data/:/etc/prometheus/"
        state: started
        restart_policy: unless-stopped
    
    - name: Create Grafana container
      docker_container:
        name: "grafana"
        image: "grafana/grafana-oss"
        detach: yes
        networks:
          - name: "monitoring_net"
        ports:
          - "80:3000"
        env:
          GF_SECURITY_ADMIN_PASSWORD: "VOMDITE"
          GF_AUTH_BASIC_ENABLED: "true"
        state: started
        restart_policy: unless-stopped
    
    - name: Pause for 30 seconds to build app
      pause:
        seconds: 30

    - name: Load default datasource
      grafana_datasource:
        name: Prometheus
        grafana_url: http://${VMNETWORKCIDR}.${MONADDRESS}/
        url_username: "admin"
        url_password: "VOMDITE"
        ds_type: prometheus
        ds_url: http://prometheus-server:9090/
        access: proxy
        is_default: yes
        tls_skip_verify: true

    - name: Load default dashboards (Node-exporter)
      grafana_dashboard:
        grafana_url: http://${VMNETWORKCIDR}.${MONADDRESS}/
        url_username: "admin"
        url_password: "VOMDITE"
        dashboard_id: 1860
        dashboard_revision: 23

    - name: Load default dashboards (Blackbox-exporter)
      grafana_dashboard:
        grafana_url: http://${VMNETWORKCIDR}.${MONADDRESS}/
        url_username: "admin"
        url_password: "VOMDITE"
        dashboard_id: 13659
        dashboard_revision: 1

    - name: Load default dashboards (Mikrotik SNMP)
      grafana_dashboard:
        grafana_url: http://${VMNETWORKCIDR}.${MONADDRESS}/
        url_username: "admin"
        url_password: "VOMDITE"
        dashboard_id: 11589
        dashboard_revision: 3

    - name: Load default dashboards (ESXi-exporter)
      grafana_dashboard:
        grafana_url: http://${VMNETWORKCIDR}.${MONADDRESS}/
        url_username: "admin"
        url_password: "VOMDITE"
        dashboard_id: 11243
        dashboard_revision: 1

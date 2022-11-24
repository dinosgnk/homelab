all:
  hosts:
%{ for hostname, ip in hosts ~}
    ${hostname}:
      ansible_host: ${ip}
      ip: ${ip}
      access_ip: ${ip}
%{ endfor ~}

  children:
    kube_control_plane:
      hosts:
%{ for hostname in keys(masters) ~}
        ${hostname}:
%{ endfor ~}

    etcd:
      hosts:
%{ for hostname in keys(masters) ~}
        ${hostname}:
%{ endfor ~}

    kube_node:
      hosts:
%{ for hostname in keys(hosts) ~}
        ${hostname}:
%{ endfor ~}

    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
        
    calico_rr:
      hosts: {}
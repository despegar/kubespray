#cloud-config
cloud_config_modules:
  - [ resolv_conf, always ]
unverified_modules: [ 'resolv_conf' ]
manage_resolv_conf: true
resolv_conf:
  nameservers: [ '127.0.0.53' ]
  searchdomains:
    - ${cluster_domain}
write_files:
  - path: /etc/systemd/resolved.conf
    content: |
      [Resolve]
      #DNS=
      #FallbackDNS=
      Domains=${cluster_domain}
      #LLMNR=no
      #MulticastDNS=no
      #DNSSEC=no
      #Cache=yes
      #DNSStubListener=yes
    owner: root:root
    permissions: '0644'

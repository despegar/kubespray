#cloud-config

# Domain name resolution
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

# Ephemeral space with LVM for topolvm
mounts:
 - [ ephemeral0 ]
bootcmd:
 - [ sh, -c, "if ! vgdisplay ephemeral > /dev/null 2>&1; then pvcreate -f /dev/vdb; vgcreate ephemeral /dev/vdb; fi" ]

#cloud-config
cloud_config_modules:
  - [ resolv_conf, always ]
unverified_modules: [ 'resolv_conf' ]
manage_resolv_conf: true
resolv_conf:
  nameservers: [ '127.0.0.53' ]
  searchdomains:
    - ${cluster_domain}

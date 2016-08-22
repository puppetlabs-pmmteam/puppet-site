class profile::firewall {
  case $::osfamily {
    default: {

      #Docker manages its own firewall rules so we shouldn't purge ones
      #we don't recognize
      if ! $networking['interfaces']['docker0'] {
        resources { 'firewall':
          purge => true,
        }
      }
    }
    'windows', 'Solaris': {
      warning("osfamily ${::osfamily} not supported by profile::firewall")
    }
  }

}

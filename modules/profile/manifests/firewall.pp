class profile::firewall {
  case $::osfamily {
    default: {

      resources { 'firewall':
        purge => true,
      }

    }
    'windows', 'Solaris': {
      warning("osfamily ${::osfamily} not supported by profile::firewall")
    }
  }

}

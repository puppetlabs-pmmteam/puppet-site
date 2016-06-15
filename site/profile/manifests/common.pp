#
# This profile is intended to set a common platform for all nodes in the
# environment. As soon as there is a "one-off" node that needs to not have some
# configuration that's defined in here, then that configuration isn't common
# and shouldn't be here.
#
class profile::common {
  include profile::pe_env
  include profile::firewall

  case $::osfamily {
    default: { } # for OS's not listed, do nothing
    'RedHat': {
      include epel
    }
  }

  if $::kernel == 'Linux' {
    service { 'NetworkManager':
      ensure => stopped,
      enable => false,
    }

    package { 'wget':
      ensure => installed,
    }
  }
}

class profile::grub {
  file { '/etc/grub.conf':
    ensure => file,
    source => '/boot/grub/grub.conf',
  }
}

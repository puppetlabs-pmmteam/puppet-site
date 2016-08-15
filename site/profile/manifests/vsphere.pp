class profile::vsphere(
  $host,
  $username,
  $password,
) {

  file { '/etc/puppetlabs/puppet/vcenter.conf':
    content => epp('profile/vcenter.conf.epp', {'username' => $username, 'password' => $password, 'host' => $host }),
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
  }

}

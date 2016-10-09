class profile::apache::remove {
  package { 'httpd':
    ensure  => absent,
    require => [Package['php'], Service['httpd']],
  }

  service { 'httpd':
    ensure => stopped,
  }

  package { 'php':
    ensure => absent,
  }
}

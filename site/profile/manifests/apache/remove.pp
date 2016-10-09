class profile::apache::remove {
  package { 'httpd':
    ensure  => absent,
    require => [Package['php'], Service['httpd']],
  }

  service { 'httpd':
    ensure => absent,
  }

  package { 'php':
    ensure => absent,
  }
}

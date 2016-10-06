class profile::apache::remove {
  package { 'apache':
    ensure  => absent,
    require => Package['php'],
  }

  package { 'php':
    ensure => removed,
  }
}

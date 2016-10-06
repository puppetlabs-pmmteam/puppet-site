class profile::nginx {
  class { 'php': 
    composer => false,
  }
  class { 'nginx': }
}

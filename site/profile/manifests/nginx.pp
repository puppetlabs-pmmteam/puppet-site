class profile::nginx {
  class { 'php': }
  class { 'nginx': }
}

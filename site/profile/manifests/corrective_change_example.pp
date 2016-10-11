class profile::corrective_change_example {
  exec { 'Execute every run':
    command => '/bin/ls /',
  }
}

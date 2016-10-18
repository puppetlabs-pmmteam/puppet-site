class role::dsc::fail {

  include profile::windows::baseline

  # runtime error during application of resource
  dsc_file {'bad_test_dir':
    dsc_ensure          => 'present',
    dsc_type            => 'Directory',
    dsc_destinationpath => 'Q:/not/here'
  }

  # Puppet parameter validation won't run your manifest
  # dsc_file {'puppet_validation':
  #  dsc_ensure          => 'present',
  #  dsc_type            => 'Thing',
  #  dsc_destinationpath => 'C:\\'
  # }

}

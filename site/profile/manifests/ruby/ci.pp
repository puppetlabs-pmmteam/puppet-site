class profile::ruby::ci {
  include ruby
  include ruby::dev

  package { 'rspec':
    ensure   => installed,
    provider => gem,
  }
}

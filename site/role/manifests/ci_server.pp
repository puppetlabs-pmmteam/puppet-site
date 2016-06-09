class role::ci_server {
  include profile::jenkins
  include profile::git
  include profile::ruby::ci
}

class profile::network::base::interfaces(
  $interfaces,
) {

  Cisco_interface {
    shutdown        => false,
    switchport_mode => disabled,
  }

  create_resources('cisco_interface', $interfaces)
}

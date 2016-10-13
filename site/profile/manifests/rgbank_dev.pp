class profile::rgbank_dev (
  $source = undef,
  $revision = undef,
) {

  Vcsrepo <| tag == 'rgbank::web' |> {
    source   => $source,
    revision => $revision,
    force    => true,
  }

}

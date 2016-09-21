
## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  path   => false,
  #server => $::puppet_server,
}

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

Package { allow_virtual => 'false' }

if $::osfamily == 'windows' {
  File {
    source_permissions => ignore,
  }
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default { }


# Docker images
node /^rgbank-web.*dockerbuilder/ {
  include role::rgbank::web
}

# APPLICATIONS
# Site application instances

site {
  $environment = get_compiler_environment()

  if $environment == 'produciton' {
    rgbank { 'getting-started':
      listen_port => 8010,
      nodes => {
        Node['database.vm'] => [Rgbank::Db[getting-started]],
        Node['appserver01.vm'] => [Rgbank::Web[appserver-01_getting-started]],
        Node['loadbalancer.vm'] => [Rgbank::Load[getting-started]],
      },
    }
  }

  # Dynamic application declarations
  # from JSON
  $envs = loadyaml("/etc/puppetlabs/code/environments/${environment}/applications.yaml")
  $applications = pick_default($envs[$environment], {})

  $applications.each |String $type, $instances| {
    $instances.each |String $title, $params| {
      $parsed_parameters = $params.make_application_parameters($title)

      # Because Puppet code expects typed parameters, not just strings representing
      # types, an appropriately transformed version of the $params variable will be
      # used. The resolve_resources() method comes from the tse/to_resource module.
      Resource[$type] { $title:
        * => $parsed_parameters.resolve_resources
      }
    }
  }
}

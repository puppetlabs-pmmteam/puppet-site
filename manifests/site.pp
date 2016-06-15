
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


# APPLICATIONS
# Site application instances

site {
  
  $applications = lookup('applications')

  $applications.each |String $type, Hash $instances| {
    $instances.each |String $title, Hash $params| {
      Resource[$type] { $title:
        * => $params.resource_resources,
      }
    }
  }

  #rgbank { 'staging':
  #  web_count => 2,
  #  nodes     => {
  #    Node['appserver01.vm']  => [ Rgbank::Web['staging-0'] ],
  #    Node['appserver02.vm']  => [ Rgbank::Web['staging-1'] ],
  #    Node['loadbalancer.vm'] => [ Rgbank::Load['staging'] ],
  #    Node['database.vm']     => [ Rgbank::Db['staging'] ],
  #  },
  #}

  #rgbank { 'dev':
  #  nodes               => {
  #    Node['rgbankdev.vm'] => [ Rgbank::Web['dev-0'],
  #                           Rgbank::Load['dev'],
  #                           Rgbank::Db['dev'] ],
  #  },
  #}
}

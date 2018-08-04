class hosts(
  String $target = ::hosts::get_default_hosts_path(),
  Boolean $enable_defaults = true,
  Array[Hash] $hosts = []
){
  $target_alias = '::hosts:hosts'
  concat { $target_alias:
    ensure         => present,
    ensure_newline => true,
    path           => $target
  }

  $_header = "# HEADER: This file is managed by puppet\n\
# HEADER: While it can still be managed manually, it\n\
# HEADER: is definitely not recommended.\n"

  concat::fragment { 'hosts:header':
    target  => '::hosts:hosts',
    order   => '00',
    content => $_header
  }

  if $enable_defaults {

    hosts::host { 'localhost':
      ip      => '127.0.0.1',
      aliases => ['localhost.localdomain', 'localhost', 'localhost4', 'localhost4.localdomain4']
    }

    hosts::host {'ip6-localhost':
      ip      => '::1',
      aliases => ['localhost6.localdomain6', 'localhost6', 'ip6-localhost', 'ip6-loopback']
    }
    hosts::host { 'ip6-localnet': ip => 'fe00::0'}
    hosts::host { 'ip6-mcastprefix': ip => 'ff00::0'}
    hosts::host { 'ip6-allnodes': ip => 'ff02::1'}
    hosts::host { 'ip6-allrouters': ip => 'ff02::2'}
    hosts::host { 'ip6-allhosts': ip => 'ff02::3'}
  }

  $hosts.each | $index, $conf | {
    hosts::host { "hosts:auto-host:${index}":
      * => $conf
    }
  }
}

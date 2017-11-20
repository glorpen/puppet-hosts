class hosts(
  String $target = '/etc/hosts',
  Boolean $enable_defaults = true,
  Array $hosts = []
){
  concat { $target:
    ensure => present,
    ensure_newline => true 
  }
  
  concat::fragment { "hosts:header":
    target => $target,
    order => '00',
    content => @("HEADER"/L)
# HEADER: This file is managed by puppet
# HEADER: While it can still be managed manually, it
# HEADER: is definitely not recommended.
    | HEADER
  }
  
  if $enable_defaults {
    
    hosts::host { 'localhost':
      ip => '127.0.0.1',
      aliases => ['localhost.localdomain', 'localhost', 'localhost4', 'localhost4.localdomain4']
    }
    
    hosts::host {'ip6-localhost':
      ip => '::1',
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

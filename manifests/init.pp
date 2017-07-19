class hosts(
  String $target = '/etc/hosts',
  Boolean $enable_defaults = true,
  Boolean $enable_fqdn_entry = true
){
  concat { $target:
    ensure => present,
  }
  
  if $enable_defaults {
    hosts::host {'ip6-localhost':
      ip => '::1',
      aliases => ['ip6-localhost', 'ip6-loopback']
    }
    hosts::host { 'ip6-localnet': ip => 'fe00::0'}
    hosts::host { 'ip6-mcastprefix': ip => 'ff00::0'}
    hosts::host { 'ip6-allnodes': ip => 'ff02::1'}
    hosts::host { 'ip6-allrouters': ip => 'ff02::2'}
    hosts::host { 'ip6-allhosts': ip => 'ff02::3'}
  }
}

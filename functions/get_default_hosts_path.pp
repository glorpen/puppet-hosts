function hosts::get_default_hosts_path() >> String {
  case $::facts['os']['family'] {
    'windows' : {
        if $::facts['os']['windows'] and $::facts['os']['windows']['system32'] {
            "${::facts['os']['windows']['system32']}\\drivers\\etc\\hosts"
        } elsif $::facts['system32'] {
            "${::facts['system32']}\\drivers\\etc\\hosts"
        } else {
            fail('No system32 fact found')
        }
    }
    default : { '/etc/hosts' }
  }
}

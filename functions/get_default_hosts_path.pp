function hosts::get_default_hosts_path() >> String {
  case $::facts['os']['family'] {
    'windows' : {
        "${::facts['os']['windows']['system32']}\\drivers\\etc\\hosts"
    }
    default : { '/etc/hosts' }
  }
}

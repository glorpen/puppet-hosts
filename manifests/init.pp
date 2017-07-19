class hosts(
  String $target = '/etc/hosts'
){
  concat { $target:
    ensure => present,
  }
}

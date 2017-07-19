define hosts::host(
  String $ip,
  Variant[String, Array] $aliases = $name
){
  include ::hosts
  
  if $aliases =~ Array {
    $_aliases = String($aliases, {
      Array=>{
        separator => "",
        format => "% s",
        string_formats => {String=>"%s"}
      }
    })
  } else {
    $_aliases = $aliases
  }
  
  $_ip = String($ip, {
    String => {
      format => "%-24s"
    }
  })
  
  concat::fragment { "hosts:host:${name}":
    target  => $::hosts::target,
    content => "${_ip}${_aliases}",
    order => '01'
  }
}

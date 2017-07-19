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
  
  concat::fragment { "g_hosts::${name}":
    target  => $::g_hosts::target,
    content => "${ip} ${aliases}",
    order => '01'
  }
}

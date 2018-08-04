define hosts::host(
  String $ip,
  Variant[String, Array] $aliases = $name
){
  include ::hosts

  # IPv6 addresses can be long
  $padding = ceiling(length($ip) / 12.0) * 12 + 1

  $_ip = String($ip, {
    String => {
      format => "%-${padding}s"
    }
  })

  if $::facts['os']['family'] == 'windows' {
    if $aliases =~ String {
      $_aliases = [$aliases]
    } else {
      $_aliases = $aliases
    }

    $config = Hash($_aliases.map |$alias| {
      [
        "hosts:host:${name}:${alias}",
        {
          'target'  => $::hosts::target,
          'content' => "${_ip}${alias}"
        }
      ]
    })

  } else {
    if $aliases =~ Array {
      $_aliases = regsubst(String($aliases, {
        Array=>{
          separator => ' ',
          format => '% s',
          string_formats => {String=>'%s'}
        }
      }), ' {2,}', ' ')
    } else {
      $_aliases = $aliases
    }

    $config = {
      "hosts:host:${name}" => {
        'target'  => $::hosts::target,
        'content' => "${_ip}${_aliases}",
      }
    }
  }

  create_resources('concat::fragment', $config)
}

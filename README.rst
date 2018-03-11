====================
glorpen/puppet-hosts
====================

Yet another ``/etc/hosts`` manager. Hopefully better :)

Default hosts
=============

By default, including ``hosts`` will setup default hosts:

.. sourcecode:: text

   ff02::3                 ip6-allhosts
   ff02::1                 ip6-allnodes
   ff02::2                 ip6-allrouters
   ::1                     localhost6.localdomain6 localhost6 ip6-localhost ip6-loopback
   fe00::0                 ip6-localnet
   ff00::0                 ip6-mcastprefix
   127.0.0.1               localhost.localdomain localhost localhost4 localhost4.localdomain4

To disable this behavior pass ``enable_defaults=false``.

Custom hosts
============

To create custom host entries you can pass list of them to ``hosts`` class as ``hosts`` parameter or just use ``hosts::host`` type.

.. sourcecode:: puppet

   hosts::host { "name-used-as-host":
     ip => '192.168.0.1'
   }
   hosts::host { "example0":
      ip => '192.168.0.2',
      aliases => 'example-host'
   }
   hosts::host { "example1":
      ip => '192.168.0.3',
      aliases => ['example-host0', 'example-host1']
   }


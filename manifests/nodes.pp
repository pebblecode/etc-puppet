
node 'spiderpig.pebblecode.net' {
  include motd
  include nginx
  file { "/etc/nginx/sites-available/test.conf":
	  owner   => root,
		  group   => root,
		  mode    => 644,
		  source  => "puppet:///modules/nginx/test.conf",
		  require => Package["nginx"],
  }
}

import 'quimby'
import 'herman'
import 'frink'
import 'lois'
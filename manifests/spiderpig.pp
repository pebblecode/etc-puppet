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
  class { openssh-server: ssh_port => 7234 }
  class { iptables: ssh_port => 7234 }
}
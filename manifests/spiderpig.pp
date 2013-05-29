node 'spiderpig.pebblecode.net' {

  include motd

  class { openssh-server: ssh_port => 7234 }
  class { iptables: ssh_port => 7234 }

  package { [ 'git', 'tmux', 'vim' ]:
    ensure => installed
  }

  apt::source { 'nginx':
    location   => 'http://ppa.launchpad.net/chris-lea/nginx-devel/ubuntu',
    repos      => 'main',
    key        => 'C7917B12',
    key_server => 'keyserver.ubuntu.com',
    notify => Package['nginx'],
  }

  package { [ 'nginx' ]:
    require => Apt::Source['nginx'],
    ensure => latest,
    notify   => Service['nginx'],
  }

  service { 'nginx':
    ensure  => 'running',
    enable  => 'true',
    require => Package['nginx'],
  }

  file { "/etc/nginx/sites-available/default":
    ensure => 'absent',
    require => Package['nginx']
  }

  file { "/etc/nginx/nginx.conf":
      mode => 644,
      owner => root,
      group => root,
      require => Package['nginx'],
      source => "puppet:///nginx/nginx.conf"
  }

  file { "/etc/nginx/conf.d/proxy.conf":
      mode => 644,
      owner => root,
      group => root,
      require => Package['nginx'],
      source => "puppet:///nginx/conf.d/proxy.conf"
  }

  file { "/etc/nginx/sites-available/regsitry.pebblecode.net":
      mode => 644,
      owner => root,
      group => root,
      require => Package['nginx'],
      source => "puppet:///nginx/vhosts/registry.pebblecode.net"
  }

  file { "/etc/nginx/sites-enabled/regsitry.pebblecode.net":
    ensure => 'link',
    require => [ Package['nginx'], File['/etc/nginx/sites-available/registry.pebblecode.net'] ],
    target => '/etc/nginx/sites-available/bede-chat',
    notify  => Service["nginx"]
  }

}

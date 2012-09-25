
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

node 'quimby.pebblecode.net' {
  package { [ 'vim','openssh-server', 'git', 'zsh']:
    ensure => latest
  }

  include ntp
  include motd

  user { 'george':
    name => 'george',
    managehome => true,
    ensure => present,
    shell => '/usr/bin/zsh',
    require => Package['zsh']
  }
  file { "/home/george/.ssh":
    ensure  => directory,
    owner   => george,
    group   => george,
    mode    => 700,
    require => User['george']
  }
  ssh_authorized_key { 'george':
    user => 'george',
    ensure => present,
    key => "AAAAB3NzaC1yc2EAAAABIwAAAQEAzqXyjW94aqdmBDZ5EEHwHW5TxptgVn0QcmcRaXOJC0wgz1U6fQ/6kmfeBEF+WY3H084UzeaPwZ2jXzpLkTHevi2RgADKKQtyLjAnhhXJgZ3N5u1QvU6tnizMXENK2nkt65fPmvygCWGP8wq4iujGIBt5Y48hxPGC2BAuH5AYjPx7TzZyeH9trAfrFdxugZ1Cq+HbKq2ahG9yClhfvG2y9LBrk/+5BCOiqzbhnOfD+Txl6+VVZqwdMARzGQT9DVfj62sp6t6ZBb5e6mrrETutiEcd08yOObzlwFCMGzjSQj0vdo0AKFsNx7F7eIQBK72s9QL6/PEKzcQgJcnJll9nzw==",
    name => "george@shapeshed.com",
    type => ssh-rsa,
    require => File['/home/george/.ssh']
  }
  exec {
    'dotfiles':
      creates => '/home/george/dotfiles',
      path    => '/bin:/usr/bin',
      command => 'su -c "git clone git://github.com/shapeshed/dotfiles.git /home/george/dotfiles && cd /home/george/dotfiles && /usr/bin/ruby install.rb" george',
      require => [Package['git'], User['george']]
  }
}

node 'herman.pebblecode.net' {
  $mysql_password = "secret"
  package { [ 'vim','openssh-server', 'git', 'zsh']:
    ensure => latest
  }
  include ntp
  include mysql::server
  include motd
  class { 'iptables': ssh_port => 22 }

}
node 'frink.pebblecode.net' {
  $mysql_password = 'gipredips'
  package { ['vim', 'openssh-server', 'git', 'zsh']: ensure => latest }
  include ntp
  include mysql::server
  include motd
  class { 'iptables': ssh_port => 22 }
}

node 'herman.pebblecode.net' {
  package { [ 'vim','openssh-server', 'git', 'zsh']:
    ensure => latest
  }
  # PPA for node
  # deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main 
  # deb-src http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main 
  file { "/etc/apt/sources.list.d":
    ensure => directory,
  }
  file { 'nodejs-ppa':
    path => "/etc/apt/sources.list.d/ppa-nodejs.list",
    ensure => file,
    content => "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main\ndeb-src http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main",
    require => File["/etc/apt/sources.list.d"]
  }
  exec { 'sign-nodejs-ppa':
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => 'sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12',
    require => File['nodejs-ppa'],
  }
  exec{ "/usr/bin/apt-get update":
    alias => 'aptgetupdate',
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    require => Exec['sign-nodejs-ppa'],
  }
  package { 'nodejs':
    ensure => installed,
    require => Exec['aptgetupdate']
  }
  include ntp
  include motd
  include couchdb
  class { 'iptables': ssh_port => 22 }
  class { 'couchdb': bind => '0.0.0.0' }
  user { 'pebble':
    name => 'pebble',
    managehome => true,
    ensure => present
  }
  file { "/home/pebble/.ssh":
    ensure => directory, 
    owner => pebble,
    group => pebble,
    mode => 700,
    require => User['pebble']
  }
  ssh_authorized_key { 'herman-george':
    user => 'pebble',
    ensure => present,
    key => "AAAAB3NzaC1yc2EAAAABIwAAAQEAzqXyjW94aqdmBDZ5EEHwHW5TxptgVn0QcmcRaXOJC0wgz1U6fQ/6kmfeBEF+WY3H084UzeaPwZ2jXzpLkTHevi2RgADKKQtyLjAnhhXJgZ3N5u1QvU6tnizMXENK2nkt65fPmvygCWGP8wq4iujGIBt5Y48hxPGC2BAuH5AYjPx7TzZyeH9trAfrFdxugZ1Cq+HbKq2ahG9yClhfvG2y9LBrk/+5BCOiqzbhnOfD+Txl6+VVZqwdMARzGQT9DVfj62sp6t6ZBb5e6mrrETutiEcd08yOObzlwFCMGzjSQj0vdo0AKFsNx7F7eIQBK72s9QL6/PEKzcQgJcnJll9nzw==",
    name => "george@shapeshed.com",
    type => 'ssh-rsa',
    require => File['/home/pebble/.ssh']
  }
  ssh_authorized_key { 'herman-vince':
    user => 'pebble',
    ensure => present,
    key => "AAAAB3NzaC1kc3MAAACBAO5wzW+gRqQDDkfC602e7meBvNtzH/tZm1ysdrgA4A8TZ2Tv6J0KyWCNRkevQzGGc4/rXLWDrsPjG0i5/DFAzXfgVqdsh+Z3fwC6Gc+l4avKOaH8A9RB4kzbr/rSnPEZ7qY6PtgAbDcJzaJWtCgLYc6zKown/8Z2ac7TOPdDUwOVAAAAFQCsW77YakMKmAyTBX+kTomV0+lkXwAAAIEAqB1SQrQPAk6w90dClN+dCbkczmljrlGrmc+il2dxPGlVjflK84/GjonGpPDpL347aCH1icUtJyCO5cDJIP8E4IDPNLxROyV0OLlvR2j5UlrmcZjRZcscPoqM1nE+sNxBsEDfCJ0H7TW3MFAKIoqttR324q7HBP04LoHIQlUL1dYAAACAYWeMjrGUxH4g1MWgmB3q39VvnnpQOVhifqXXGwgmba38V9UAfHEJhPT3xkHKf2yJujWRmoHYtyl5pZ+l4KVH4+Hy0Nne1nnxR0RbRLxhTXAh7CEDiJiHpVXtNvU56HUhLFnkwOfUFzw1amKsfdbpfnyhZURKcyBnppUSvBGONQ0=",
    name => "eykosioux@gmail.com",
    type => 'ssh-dss',
    require => File['/home/pebble/.ssh']
  }
  ssh_authorized_key { 'herman-tak':
    user => 'pebble',
    ensure => present,
    key => "AAAAB3NzaC1yc2EAAAABIwAAAQEAmvXEbaRcHV8hHcBOFDO098J6m6m9Lnka47KXApE9uh7QFumQpgTxu0Z2xHaz5FfcvQkoQ5XquseXrKvG4bZyrkemBm11VExJ3Pne06fQf/xmDtDgF735UbvngOZKQvZBqVmVsQewtLHNd8jot1k/6vwXvwOHueab+cEXbxq6zBzYvAU8XZjpdAFh2NJRoADQ1+Nwa1ni/HARlWyvyqRAcRtQUmQrsfiUInLrOFBB4HgQ+hNHHNfljg/vRTi4I08FNc4vmUcKyhaeEMJ0+UzyGk3XWQx067DYFq7UAB9NiVKmJBXI1ynoAeLXbnNf3CY2B7dH4/V6PrS8kdE7rJgRHQ==",
    name => "ttt@Macintosh-4.local",
    type => 'ssh-rsa',
    require => File['/home/pebble/.ssh']
  }
}

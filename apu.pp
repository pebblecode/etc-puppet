node 'apu.pebblecode.net' {
  include motd
  include nginx
  class { 'iptables': ssh_port => 22 }
  ssh_authorized_key { 'frink-vince':
    user => 'pebble',
    ensure => present,
    key => "AAAAB3NzaC1kc3MAAACBAO5wzW+gRqQDDkfC602e7meBvNtzH/tZm1ysdrgA4A8TZ2Tv6J0KyWCNRkevQzGGc4/rXLWDrsPjG0i5/DFAzXfgVqdsh+Z3fwC6Gc+l4avKOaH8A9RB4kzbr/rSnPEZ7qY6PtgAbDcJzaJWtCgLYc6zKown/8Z2ac7TOPdDUwOVAAAAFQCsW77YakMKmAyTBX+kTomV0+lkXwAAAIEAqB1SQrQPAk6w90dClN+dCbkczmljrlGrmc+il2dxPGlVjflK84/GjonGpPDpL347aCH1icUtJyCO5cDJIP8E4IDPNLxROyV0OLlvR2j5UlrmcZjRZcscPoqM1nE+sNxBsEDfCJ0H7TW3MFAKIoqttR324q7HBP04LoHIQlUL1dYAAACAYWeMjrGUxH4g1MWgmB3q39VvnnpQOVhifqXXGwgmba38V9UAfHEJhPT3xkHKf2yJujWRmoHYtyl5pZ+l4KVH4+Hy0Nne1nnxR0RbRLxhTXAh7CEDiJiHpVXtNvU56HUhLFnkwOfUFzw1amKsfdbpfnyhZURKcyBnppUSvBGONQ0=",
    name => "eykosioux@gmail.com",
    type => 'ssh-dss',
    require => File['/home/pebble/.ssh']
  }
  # Mysql
  $mysql_password = '0rcimrepus'
  include mysql::server
  # Postgres: https://github.com/inkling/puppet-postgresql
  # $postgres_password = 'fr1nkp0stgr3sfr1nk'
  class { 'postgresql::server':
    config_hash => {
      'ip_mask_allow_all_users' => '0.0.0.0/0',
      'listen_addresses' => '*',
      'postgres_password' => 'fr1nkp0stgr3sfr1nk',
    }
  }
  exec { "mysql-access-subnet1":
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => "mysql -uroot -p${mysql_password} -e \"GRANT ALL PRIVILEGES ON *.* to 'root'@'192.168.3.%' IDENTIFIED BY '${mysql_password}' WITH GRANT OPTION;\"",
    require => Exec['set-mysql-password'],
  }
  exec { "mysql-access-subnet2":
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => "mysql -uroot -p${mysql_password} -e \"GRANT ALL PRIVILEGES ON *.* to 'root'@'10.128.%.%' IDENTIFIED BY '${mysql_password}' WITH GRANT OPTION;\"",
    require => Exec['set-mysql-password'],
  }
      
}

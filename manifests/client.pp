#
class bacula::client(
  Enum['present','absent'] $ensure = 'present',
  String $director,
  String $myname                   = $::fqdn,
  String $myip                     = $::ipaddress,
  String $port                     = $bacula::params::client_port,
  String $password,
  Array[String] $fileset           = [],
  Optional[Array] $exclude         = [],
  String $signature                = 'MD5',
  Optional[String] $compression    = 'GZIP9',
  Optional[String] $monitor_pass   = undef,
) inherits bacula::params {

  package { $bacula::params::client_package_name:
    ensure => $ensure ? { 'present' => 'present', 'absent' => 'purged' },
  }

  file { $bacula::params::client_cfgfile:
    ensure  => $ensure,
    content => template('bacula/bacula-fd.conf.erb'),
    require => Package[$bacula::params::client_package_name],
    notify  => Service[$bacula::params::client_service_name],
  }

  @@bacula::server::client { $myname:
    ensure      => $ensure,
    address     => $myip,
    password    => $password,
    port        => $port,
    signature   => $signature,
    compression => $compression,
    fileset     => $fileset,
    exclude     => $exclude,
    tag         => "director-${director}",
  }

  service { $bacula::params::client_service_name:
    ensure => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable => $ensure ? { 'present' => true,      'absent' => undef },
  }
}

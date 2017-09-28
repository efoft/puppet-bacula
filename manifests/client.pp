#
class bacula::client(
  Enum['present','absent'] $ensure = 'present',
  String $director_name,
  String $client_name              = "${::fqdn}:fd",
  String $client_port              = $bacula::params::client_port,
  Optional[String] $myip           = undef,
  String $address                  = $::fqdn,
  String $password,
  Array[String] $fileset           = [],
  Optional[Array] $exclude         = [],
  String $signature                = 'MD5',
  Optional[String] $compression    = 'GZIP9',
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

  @@bacula::server::client { $client_name:
    ensure      => $ensure,
    address     => $myip ? { undef => $address, default => $myip },
    password    => $password,
    port        => $client_port,
    signature   => $signature,
    compression => $compression,
    fileset     => $fileset,
    exclude     => $exclude,
    tag         => ["director-${director_name}"],
  }

  service { $bacula::params::client_service_name:
    ensure => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable => $ensure ? { 'present' => true,      'absent' => undef },
  }
}

#
class bacula::storage(
  Enum['present','absent'] $ensure = 'present',
  String $director_name,
  String $storage_pass,
  Optional[String] $monitor_pass   = undef,
  String $storage_port             = $bacula::params::storage_port,
  String $storage_name             = $bacula::params::storage_name,
  String $device_name              = $bacula::params::device_name,
  String $media_type               = $bacula::params::media_type,
  String $myaddress                = $::fqdn,
  Stdlib::Absolutepath $storage_dir,
) inherits bacula::params {

  package { $bacula::params::storage_package_name:
    ensure => $ensure ? { 'present' => 'present', 'absent' => 'purged' },
  }

  file { $bacula::params::storage_cfgfile:
    ensure  => $ensure,
    content => template('bacula/bacula-sd.conf.erb'),
    require => Package[$bacula::params::storage_package_name],
    notify  => Service[$bacula::params::storage_service_name],
  }

  @@bacula::server::storage { $storage_name:
    ensure   => $ensure,
    address  => $myaddress,
    password => $storage_pass,
    tag      => ["director-${director_name}"],
  }

  service { $bacula::params::storage_service_name:
    ensure => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable => $ensure ? { 'present' => true,      'absent' => undef },
  }
}

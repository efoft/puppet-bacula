# === Class bacula::storage ===
# Installs and configures bacula storage. Default values below are for
# storing backups in local directory.
#
# === Parameters ===
# [*director*]
#   Fully qualified and/or resolvable hostname where director resides.
#
# [*password*]
#   Password string for access this storage from director.
#
# [*myname*]
#   The name of the storage. Don't change the default unless the same change
#   is done on director side. This hasn't been tested.
#
# [*myip*]
#   IP on which storage listens.
#
# [*port*]
#   TCP port on which storage listens.
#
# [*device_name*]
#   Default: FileStorage
#
# [*media_type*]
#   Type of device with *device_name*.
#   Default: File
#
# [*storage_dir*]
#   Path to directory (or storage device like tape library)
#
class bacula::storage(
  Enum['present','absent'] $ensure = 'present',
  String $director,
  String $password,
  String $myname                   = $::fqdn,
  Stdlib::Compat::Ipv4 $myip       = $::ipaddress,
  Numeric $port                    = $bacula::params::storage_port,
  String $device_name              = $bacula::params::device_name,
  String $media_type               = $bacula::params::media_type,
  Optional[String] $monitor_pass   = undef,
  Stdlib::Unixpath $storage_dir,
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

  @@bacula::server::storage { $myname:
    ensure   => $ensure,
    address  => $myip,
    password => $password,
    tag      => "director-${director}",
  }

  service { $bacula::params::storage_service_name:
    ensure => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable => $ensure ? { 'present' => true,      'absent' => undef },
  }
}

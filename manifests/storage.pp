#
# @summary   Installs and configures bacula storage.
#
# @param myname         Resolvable hostname where storage daemon resides.
# @param director_name  The name of the director as it's named in bacula-dir.conf
# @param myip           IP on which storage listens.
# @param port           TCP port on which storage listens.
# @param password       Password string for access this storage from director.
# @param device_name    Storage device name
# @param media_type     Type of device with *device_name*.
# @param storage_dir    Path to directory (or storage device like tape library)
#
class bacula::storage(
  Enum['present','absent'] $ensure       = 'present',
  String[1]                $myname       = $bacula::params::storage_name,
  String[1]                $director_name= $bacula::params::director_name,
  Stdlib::Ip::Address      $myip         = $bacula::params::myip,
  Numeric                  $port         = $bacula::params::storage_port,
  String[1]                $password,
  String[1]                $device_name  = 'FileStorage',
  String[1]                $media_type   = 'File',
  Optional[String[1]]      $monitor_pass = undef,
  Stdlib::Unixpath         $storage_dir,
) inherits bacula::params {

  package { $storage_package_name:
    ensure => $ensure ? { 'present' => 'present', 'absent' => 'purged' },
  }

  file { $storage_cfgfile:
    ensure  => $ensure,
    content => template('bacula/bacula-sd.conf.erb'),
    require => Package[$storage_package_name],
    notify  => Service[$storage_service_name],
  }

  service { $storage_service_name:
    ensure => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable => $ensure ? { 'present' => true,      'absent' => undef },
  }
}

#
define bacula::server::storage (
  Enum['present','absent'] $ensure = 'present',
  String $address,
  String $password,
  Numeric $port                    = $bacula::params::storage_port,
  String $device_name              = $bacula::params::device_name,
  String $media_type               = $bacula::params::media_type,
) {

  if $ensure == 'present' {
    concat::fragment { "bacula-storage-${title}":
      target  => $bacula::params::server_cfgfile,
      content => template('bacula/bacula-dir-storage.erb'),
      order   => '02',
    }
  }
}

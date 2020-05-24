# @summary                 Installs and configures bacula storage.
#
# @param director_hostname Must match hostname param of bacula::director.
# @param password          Password string for access this storage from director.
# @param storage_dir       Path to storage directory (or storage device like tape library).
# @param hostname          The hostname of this sorage host. Bacula sd name is generated inside the code.
# @param port              TCP port on which storage listens.
# @param device_name       Storage device name.
# @param media_type        Type of device with *device_name*.
# @param tray_password     Separate password used by tray monitor and monitoring software.
#
class bacula::storage (
  String[1]                $password,
  Stdlib::Unixpath         $storage_dir,
  Enum['present','absent'] $ensure             = 'present',
  String[1]                $hostname           = $::fqdn,
  Numeric                  $port               = $bacula::params::storage_port,
  String[1]                $device_name        = $bacula::params::storage_device_name,
  String[1]                $media_type         = $bacula::params::storage_media_type,
  Stdlib::Host             $director_hostname  = $hostname,
  Optional[String[1]]      $tray_password      = undef,
) inherits bacula::params {

  # Internal variables
  # --------------------------------------------------------------------------------------------------
  ## director
  $director_name = "${director_hostname}:dir"

  ## storage
  $storage_name  = "${hostname}:sd"

  $storage_package_name = $bacula::params::storage_package_name
  $storage_service_name = $bacula::params::storage_service_name
  $storage_cfgfile      = $bacula::params::storage_cfgfile

  $package_ensure = $ensure ?
  {
    'absent'  => 'purged',
    'present' => 'present'
  }
  $service_ensure = $ensure ?
  {
    'present' => 'running',
    'absent'  => undef
  }
  $service_enable = $ensure ?
  {
    'present' => true,
    'absent'  => undef
  }

  # Bacule storage components
  # --------------------------------------------------------------------------------------------------
  package { $storage_package_name:
    ensure => $package_ensure,
  }

  -> file { $storage_cfgfile:
    ensure  => $ensure,
    content => template('bacula/bacula-sd.conf.erb'),
  }

  ~> service { $storage_service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}

# @summary                 Installs bacula client.
#
# @param director_hostname Must match hostname param of bacula::director.
# @param password          Password string to connect to this client from director.
# @param hostname          The hostname of this client. Bacula fd name is generated inside the code.
# @param port              TCP port on which client listens.
# @param tray_password     Separate password used by tray monitor and monitoring software.
#
class bacula::client (
  String[1]                $director_hostname,
  String[1]                $password,
  Enum['present','absent'] $ensure             = 'present',
  String[1]                $hostname           = $::fqdn,
  Numeric                  $port               = $bacula::params::client_port,
  Optional[String]         $tray_password      = undef,
) inherits bacula::params {

  # Internal variables
  # --------------------------------------------------------------------------------------------------
  ## director
  $director_name = "${director_hostname}:dir"

  ## client
  $client_package_name = $bacula::params::client_package_name
  $client_cfgfile      = $bacula::params::client_cfgfile
  $client_cfgfile_tmpl = $bacula::params::client_cfgfile_tmpl
  $client_service_name = $bacula::params::client_service_name

  $filedaemon_name     = "${hostname}:fd"

  $package_ensure = $ensure ?
  {
    'present' => 'present',
    'absent'  => 'purged'
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

  # Bacule client components
  # --------------------------------------------------------------------------------------------------
  package { $client_package_name:
    ensure => $package_ensure,
  }

  -> file { $client_cfgfile:
    ensure  => $ensure,
    content => template("bacula/${client_cfgfile_tmpl}"),
  }

  ~> service { $client_service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}

#
# @summary                Installs bacula client.
#
# @param myname           The name of this client.
# @param director_name    The name of the director as it's named in bacula-dir.conf.
# @param password         Password string to connect to this client from director.
# @param myip             IP on which client operates reachable from director side.
# @param port             TCP port on which client listens.
# @param monitoring_pass  Separate password used by tray monitor and monitoring software.
#
class bacula::client(
  Enum['present','absent'] $ensure          = 'present',
  String[1]                $myname          = $bacula::params::client_name,
  String                   $director_name   = $bacula::params::director_name,
  Stdlib::Ip::Address      $myip            = $bacula::params::myip,
  Numeric                  $port            = $bacula::params::client_port,
  String                   $password,
  Optional[String]         $monitor_pass    = undef,
) inherits bacula::params {

  package { $client_package_name:
    ensure => $ensure ? { 'present' => 'present', 'absent' => 'purged' },
  }

  $tmpl = $::kernel ?
  {
    'windows' => 'bacula-fd.conf.win.erb',
    'linux'   => 'bacula-fd.conf.erb',
  }

  file { $client_cfgfile:
    ensure  => $ensure,
    content => template("bacula/${tmpl}"),
    require => Package[$client_package_name],
    notify  => Service[$client_service_name],
  }

  service { $client_service_name:
    ensure => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable => $ensure ? { 'present' => true,      'absent' => undef },
  }
}

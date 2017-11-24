# === Class bacula::client ===
#
# === Parameters ===
# [*director*]
#   FQDN or resolvable hostname where director resides.
#
# [*myname*]
#   The name of client. Recommended to leave default.
#
# [*myip*]
#   IP on which client operates reachable from director side.
#
# [*port*]
#   TCP port on which client listens.
#
# [*password*]
#   Password string to connect to this client from director.
#
# [*fileset*]
#   Array of paths to be backed up.
#
# [*exclude*]
#   What subdirectories to exclude from *fileset*.
#
# [*signature*]
#   Hashing algorith to check data integrity.
#   Possible values: MD5, SHA1
#   Default: MD5
#
# [*compression*]
#   Optional. If specified backup data will be compressed on the fly by fd daemon.
#   Possible values: GZIP, GZIPx, LZO. GZIP = GZIP6. GZIP9 has the best compression ratio. LZO is faster but lower compression ratio.
#   Default: GZIP9
#
# [*monitor_pass*]
#   Separate password used by tray monitor and monitoring software.
#
class bacula::client(
  Enum['present','absent'] $ensure = 'present',
  String $director,
  String $myname                   = $::fqdn,
  Stdlib::Compat::Ipv4 $myip       = $::ipaddress,
  Numeric $port                    = $bacula::params::client_port,
  String $password,
  Array[String] $fileset           = [],
  Optional[Array] $exclude         = [],
  Enum['MD5','SHA1'] $signature    = 'MD5',
  String $compression              = 'GZIP9',
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

#
define bacula::server::client(
  Enum['present','absent'] $ensure = 'present',
  String $myname                   = $title,
  String $address,
  String $port                     = '9102',
  String $password,
  String $signature,
  Optional[String] $compression    = undef,
  Array $fileset,
  Array $exclude                   = [],
) {

  if $ensure == 'present' {
    concat::fragment { "client-${title}":
      target  => $bacula::params::server_cfgfile,
      content => template('bacula/bacula-dir-client.erb'),
      order   => '05',
    }
  }
}

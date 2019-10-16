#
class bacula::server(
  Enum['present','absent']   $ensure         = 'present',
  String                     $myname         = $bacula::params::director_name,
  Numeric                    $port           = $bacula::params::director_port,
  String                     $catalog_name   = $bacula::params::catalog_name,
  String                     $storage_name   = $bacula::params::storage_name,
  Stdlib::Host               $storage_addr   = $bacula::params::myip,
  Numeric                    $storage_port   = $bacula::params::storage_port,
  String                     $storage_pass,
  String                     $client_name    = $bacula::params::client_name,
  String                     $console_pass,
  Optional[String]           $monitor_pass   = undef,
  Enum['mysql','postgresql'] $dbtype         = 'postgresql',
  String                     $dbhost         = 'localhost',
  String                     $dbname         = 'bacula',
  String                     $dbuser         = 'bacula',
  String                     $dbpass,
  Enum['all','errors']       $mail_to_root   = 'errors',
  Stdlib::Unixpath           $restore_dir    = '/tmp/bacula-restores',
  Boolean                    $backup_catalog = false,
  Boolean                    $log_messages   = false,
) inherits bacula::params {

  class { 'bacula::server::install': } ->
  class { 'bacula::server::config':  } ~>
  class { 'bacula::server::service': }
}

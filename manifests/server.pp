#
class bacula::server(
  Enum['present','absent'] $ensure   = 'present',
  String $director_name              = $bacula::params::director_name,
  String $director_port              = $bacula::params::director_port,
  String $console_pass,
  String $storage_name               = $bacula::params::storage_name,
  String $storage_pass,
  Optional[String] $monitor_pass     = undef,
  String $dbname                     = $bacula::params::dbname,
  String $dbuser                     = $bacula::params::dbuser,
  String $dbpass,
  Enum['all','errors'] $mail_to_root = 'errors',
  Stdlib::Absolutepath $restore_dir  = '/tmp/bacula-restores',
  Boolean $backup_catalog            = false,
  Boolean $log_messages              = false,
  String $local_client_name          = $bacula::params::client_name,
  String $local_client_pass,
  Array $local_client_fileset        = [],
  Array $local_client_exclude        = [],
) inherits bacula::params {

  class { 'bacula::server::install': } ->
  class { 'bacula::server::config':  } ~>
  class { 'bacula::server::service': }
}

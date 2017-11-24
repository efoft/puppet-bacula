#
class bacula::server(
  Enum['present','absent'] $ensure           = 'present',
  String $myname                             = $::fqdn,
  Numeric $port                              = $bacula::params::director_port,
  String $storage_name,
  String $storage_pass,
  String $console_pass,
  Optional[String] $monitor_pass             = undef,
  Enum['mysql','postgresql'] $dbtype         = $bacula::params::dbtype,
  String $dbhost                             = $bacula::params::dbhost,
  String $dbname                             = $bacula::params::dbname,
  String $dbuser                             = $bacula::params::dbuser,
  String $dbpass,
  Enum['all','errors'] $mail_to_root         = 'errors',
  Stdlib::Unixpath $restore_dir              = '/tmp/bacula-restores',
  Boolean $backup_catalog                    = false,
  Boolean $log_messages                      = false,
  String $local_client_name                  = $::fqdn,
  String $local_client_pass,
  Optional[String] $local_client_compression = undef,
  Array $local_client_fileset                = [],
  Array $local_client_exclude                = [],
) inherits bacula::params {

  class { 'bacula::server::install': } ->
  class { 'bacula::server::config':  } ~>
  class { 'bacula::server::service': }
}

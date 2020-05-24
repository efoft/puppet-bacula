# @summary                   Installs and configures bacula director.
#
# @param password            Director password for access using bconsole.
# @param storage_password    The password of bacula-sd, if omitted then 'password' is used.
# @param hostname            The hostname of bacula director host, must be set the same on storage and clients.
# @param port                TCP port on which bacula-dir listens.
# @param storage_hostname    The hostname where bacula-sd resides. If skipped it's assumed that director & storage are on the same host.
# @param storage_address     IP or resolvable hostname on which bacula-sd can be contacted by clients.
# @param storage_port        TCP port on which bacula-sd listens.
# @param storage_device_name Must reflect the same setting in bacula-sd.
# @param storage_media_type  Must reflect the same setting in bacula-sd.
# @param tray_password       Separate optional password that can be used by tray monitor and other monitoring software.
# @param dbtype              One of 'mysql' or 'postgresql'.
# @param dbhost              The hostname/address where database resides. Defaults to 'localhost'.
# @param dbname              The name of the database.
# @param dbuser              The database username.
# @param dbpass              The password for the database user.
# @param mail_to_root        What to send to root user by email. Can be 'all' messages or 'errors' only.
# @param restore_dir         Default directory to restore backed up data. Can be changed in bconsole at restore time.
# @param backup_catalog      If to backup bacula's catalog after each client backup.
# @param log_messages        If to log messages.
#
class bacula::director (
  String[1]                  $password,
  Enum['present','absent']   $ensure              = 'present',
  String[1]                  $storage_password    = $password,
  String                     $hostname            = $::fqdn,
  Numeric                    $port                = $bacula::params::director_port,
  Stdlib::Host               $storage_hostname    = $hostname,
  Optional[Stdlib::Host]     $storage_address     = undef,
  Numeric                    $storage_port        = $bacula::params::storage_port,
  String[1]                  $storage_device_name = $bacula::params::storage_device_name,
  String[1]                  $storage_media_type  = $bacula::params::storage_media_type,
  Optional[String[1]]        $tray_password       = undef,
  Enum['mysql','postgresql'] $dbtype              = 'postgresql',
  String                     $dbhost              = 'localhost',
  String                     $dbname              = 'bacula',
  String                     $dbuser              = 'bacula',
  String                     $dbpass              = '',
  Enum['all','errors']       $mail_to_root        = 'errors',
  Stdlib::Unixpath           $restore_dir         = '/tmp/bacula-restores',
  Boolean                    $backup_catalog      = false,
  Boolean                    $log_messages        = false,
) inherits bacula::params {

  # Internal variables
  # --------------------------------------------------------------------------------------------------
  ## director
  $director_name = "${hostname}:dir"
  $catalog_name  = "${hostname}:catalog"

  ## storage
  $storage_name  = "${storage_hostname}:sd"
  $storage_addr  = $storage_address ?
  {
    undef   => $::ipaddress,
    default => $storage_address
  }

  ## local client
  $client_name   = "${hostname}:fd"

  # Director
  # --------------------------------------------------------------------------------------------------
  class { 'bacula::director::install': }
  -> class { 'bacula::director::config':  }
  ~> class { 'bacula::director::service': }
}

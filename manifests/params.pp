#
class bacula::params {

  case $::osfamily {
    'redhat': {
      $server_package_name   = 'bacula-director'
      $server_service_name   = 'bacula-dir'
      $server_cfgfile        = '/etc/bacula/bacula-dir.conf'
      $conf_d_dir            = '/etc/bacula/bacula-dir.d'
      $storage_package_name  = 'bacula-storage'
      $storage_service_name  = 'bacula-sd'
      $storage_cfgfile       = '/etc/bacula/bacula-sd.conf'
      $console_package_name  = 'bacula-console'
      $console_cfgfile       = '/etc/bacula/bconsole.conf'
      $client_package_name   = 'bacula-client'
      $client_service_name   = 'bacula-fd'
      $client_cfgfile        = '/etc/bacula/bacula-fd.conf'
      $client_workdir        = '/var/spool/bacula'
      $client_pid_dir        = '/var/run'
    }
    'windows': {
      $client_package_name   = 'bacula'
      $client_service_name   = 'bacula-fd'
      $client_cfgfile        = 'C:\\Program Files\\Bacula\\bacula-fd.conf'
      $client_workdir        = 'C:\\\\Program Files\\\\Bacula\\\\working'
      $client_pid_dir        = 'C:\\\\Program Files\\\\Bacula\\\\working'
    }
    default: {
      fail('Sorry! Your OS is not supported.')
    }
  }

  ## single source of common values
  $myip          = $::ipaddress
  $director_name = "${::fqdn}:dir"
  $director_port = 9101
  $catalog_name  = "${::fqdn}:catalog"
  $storage_name  = "${::fqdn}:sd"
  $storage_port  = 9103
  $client_name   = "${::fqdn}:fd"
  $client_port   = 9102
}

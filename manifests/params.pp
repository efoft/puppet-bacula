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
      $client_cfgfile        = '/etc/bacula/bacula-fd.conf'
      $client_workdir        = 'C:\\Program Files\\Bacula\\working'
      $client_pid_dir        = 'C:\\Program Files\\Bacula\\working'
    }
    default: {
      fail('Sorry! Your OS is not supported.')
    }
  }

  # director
  $director_port            = '9101'
  $dbtype                   = 'postgresql'
  $dbhost                   = 'localhost'
  $dbname                   = 'bacula'
  $dbuser                   = 'bacula'

  # storage
  $storage_port             = '9103'
  $device_name              = 'FileStorage'
  $media_type               = 'File'

  # client
  $client_port              = '9102'
}

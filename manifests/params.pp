#
class bacula::params {

  case $::osfamily {
    'redhat': {
      $server_package_name   = 'bacula-director'
      $storage_package_name  = 'bacula-storage'
      $client_package_name   = 'bacula-client'
      $console_package_name  = 'bacula-console'
      $server_service_name   = 'bacula-dir'
      $storage_service_name  = 'bacula-sd'
      $client_service_name   = 'bacula-fd'
      $server_cfgfile        = '/etc/bacula/bacula-dir.conf'
      $storage_cfgfile       = '/etc/bacula/bacula-sd.conf'
      $client_cfgfile        = '/etc/bacula/bacula-fd.conf'
      $console_cfgfile       = '/etc/bacula/bconsole.conf'
      $conf_d_dir            = '/etc/bacula/bacula-dir.d'
    }
    default: {
      fail('Sorry! Your OS is not supported.')
    }
  }

  # director
  $director_port            = '9101'
  $director_name            = "${::fqdn}:dir"
  $dbtype                   = 'postgresql'
  $dbhost                   = 'localhost'
  $dbname                   = 'bacula'
  $dbuser                   = 'bacula'

  # storage
  $storage_port             = '9103'
  $storage_name             = "${::fqdn}:sd"
  $device_name              = 'FileStorage'
  $media_type               = 'File'

  # client
  $client_port              = '9102'
  $client_name              = "${::fqdn}:fd"
}

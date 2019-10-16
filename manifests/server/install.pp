#
class bacula::server::install inherits bacula::server {

  assert_private('This is private class')

  $real_server_package_name = $::operatingsystemmajrelease ?
  {
    '7' => $server_package_name,
    '6' => "${server_package_name}-${dbtype}"
  }

  package { 'bacula-dir':
    name   => $real_server_package_name,
    ensure => $ensure ? { 'absent' => 'purged', 'present' => 'present' },
  }

  package { $console_package_name:
    ensure => $ensure ? { 'absent' => 'purged', 'present' => 'present' },
  }
}

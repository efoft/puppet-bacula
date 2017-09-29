#
class bacula::server::install {

  assert_private('This is private class')

  $real_server_package_name = $::operatingsystemmajrelease ?
  {
    '7' => $bacula::params::server_package_name,
    '6' => "${bacula::params::server_package_name}-${dbtype}"
  }

  package { 'bacula-dir':
    name   => $real_server_package_name,
    ensure => $bacula::server::ensure ? { 'absent' => 'purged', 'present' => 'present' },
  }

  package { $bacula::params::console_package_name:
    ensure => $bacula::server::ensure ? { 'absent' => 'purged', 'present' => 'present' },
  }

}

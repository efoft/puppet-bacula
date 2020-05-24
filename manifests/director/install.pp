#
class bacula::director::install inherits bacula::director {

  $ensure                = $bacula::director::ensure
  $director_package_name = $bacula::director::director_package_name
  $console_package_name  = $bacula::director::console_package_name
  $dbtype                = $bacula::director::dbtype

  $director_package_name_real = $::operatingsystemmajrelease ?
  {
    '7' => $director_package_name,
    '6' => "${director_package_name}-${dbtype}"
  }

  $package_ensure = $ensure ?
  {
    'absent'  => 'purged',
    'present' => 'present'
  }

  package { 'bacula-dir':
    ensure => $package_ensure,
    name   => $director_package_name_real,
  }

  package { $console_package_name:
    ensure => $package_ensure,
  }
}

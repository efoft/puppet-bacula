#
class bacula::director::config inherits bacula::director {

  $ensure           = $bacula::director::ensure
  $dbtype           = $bacula::director::dbtype
  $conf_d_dir       = $bacula::director::conf_d_dir
  $console_cfgfile  = $bacula::director::console_cfgfile
  $director_cfgfile = $bacula::director::director_cfgfile

  $directory_ensure = $ensure ?
  {
    'present' => 'directory',
    'absent'  => undef
  }

  if $ensure == 'present' {
    # In Bacula version 5.2 the way how to switch between different database backends changed.
    # It's required now to configure the backend through the alternatives system.
    # Read /usr/share/doc/bacula-common-5.x.x/README.Redhat
    exec { "switch-bacula-backend-to-${dbtype}":
      command => "alternatives --set libbaccats.so /usr/lib64/libbaccats-${dbtype}.so",
      path    => ['/usr/sbin','/usr/bin', '/bin'],
      unless  => "alternatives --list | grep libbaccats-${dbtype}.so",
      onlyif  => 'alternatives --list | grep libbaccats',
    }
  }

  file { $conf_d_dir:
    ensure => $directory_ensure,
  }

  File {
    ensure => $ensure,
  }

  file {
    $console_cfgfile:
      content => template('bacula/bconsole.conf.erb');
    $director_cfgfile:
      content => template('bacula/bacula-dir.conf.erb');
    "${conf_d_dir}/dummy.conf": # empty file to prevent errors when the conf_d directory is read for *.conf files and no one exists
  }
}

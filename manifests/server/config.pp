#
class bacula::server::config inherits bacula::server {

  if $ensure == 'present' and versioncmp($::bacula_version, '5.2.0') >= 0 {
    # In Bacula version 5.2 the way how to switch between different database backends changed.
    # It's required now to configure the backend through the alternatives system.
    # Read /usr/share/doc/bacula-common-5.x.x/README.Redhat
    exec { "switch-bacula-backend-to-${dbtype}":
      command => "alternatives --set libbaccats.so /usr/lib64/libbaccats-${dbtype}.so",
      path    => ['/usr/sbin','/usr/bin', '/bin'],
      unless  => "alternatives --list | grep libbaccats-${dbtype}.so",
    }
  }

  file { $conf_d_dir:
    ensure => $ensure ? { 'present' => 'directory', 'absent' => undef },
  }

  File {
    ensure => $ensure,
  }

  file {
    $console_cfgfile:
      content => template('bacula/bconsole.conf.erb');
    $server_cfgfile:
      content => template('bacula/bacula-dir.conf.erb'),
      notify  => Service[$server_service_name];
    "${conf_d_dir}/dummy.conf": # empty file to prevent errors when the conf_d directory is read for *.conf files and no one exists
  }
}

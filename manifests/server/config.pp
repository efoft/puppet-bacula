#
class bacula::server::config {

  assert_private('This is private class')

  file { $bacula::params::conf_d_dir:
    ensure => $bacula::server::ensure ? { 'present' => 'directory', 'absent' => undef },
  }

  # dummy.conf is an empty file that is needed just to prevent errors when the conf_d directory is read for *.conf files and no one exists
  file { "${bacula::params::conf_d_dir}/dummy.conf":
    ensure => $bacula::server::ensure,
  }

  file { $bacula::params::console_cfgfile:
    ensure  => $bacula::server::ensure,
    content => template('bacula/bconsole.conf.erb'),
  }

  concat { $bacula::params::server_cfgfile:
    ensure => $bacula::server::ensure,
    notify => Service[$bacula::params::server_service_name],
  }

  concat::fragment { 'bacula-dir.cong_start':
    target  => $bacula::params::server_cfgfile,
    content => template('bacula/bacula-dir.conf_start.erb'),
    order   => '01',
  }

  concat::fragment { 'bacula-dir.cong_end':
    target  => $bacula::params::server_cfgfile,
    content => template('bacula/bacula-dir.conf_end.erb'),
    order   => '10',
  }

  # server must always have local client installed in order to be able to run restore job
  class { '::bacula::client':
    ensure        => $bacula::server::ensure,
    director      => $bacula::server::myname,
    myname        => $bacula::server::local_client_name,
    password      => $bacula::server::local_client_pass,
    monitor_pass  => $bacula::server::monitor_pass,
    fileset       => $bacula::server::local_client_fileset,
    exclude       => $bacula::server::local_client_exclude,
  }

  contain ::bacula::server::import
}

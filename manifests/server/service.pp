#
class bacula::server::service inherits bacula::server {

  assert_private('This is private class')

  service { $server_service_name:
    ensure     => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable     => $ensure ? { 'present' => true,      'absent' => undef },
    hasstatus  => true,
    hasrestart => true,
  }
}

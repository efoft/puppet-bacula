#
class bacula::server::service inherits bacula::server {

  service { $server_service_name:
    ensure     => $ensure ? { 'present' => 'running', 'absent' => undef },
    enable     => $ensure ? { 'present' => true,      'absent' => undef },
    hasstatus  => true,
    hasrestart => true,
  }
}

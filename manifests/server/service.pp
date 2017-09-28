#
class bacula::server::service {

  service { $bacula::params::server_service_name:
    ensure     => $bacula::server::ensure ? { 'present' => 'running', 'absent' => undef },
    enable     => $bacula::server::ensure ? { 'present' => true,      'absent' => undef },
    hasstatus  => true,
    hasrestart => true,
  }
}

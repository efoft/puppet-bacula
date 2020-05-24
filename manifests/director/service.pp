#
class bacula::director::service inherits bacula::director {

  $director_service_name = $bacula::director::director_service_name
  $ensure = $bacula::director::ensure

  $service_ensure = $ensure ?
  {
    'present' => 'running',
    'absent'  => undef
  }
  $service_enable = $ensure ?
  {
    'present' => true,
    'absent'  => undef
  }

  service { $director_service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}

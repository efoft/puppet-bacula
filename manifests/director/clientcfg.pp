#
# @summary Creates per client config with client, job and fileset definitions
#
define bacula::director::clientcfg (
  Stdlib::Ip::Address          $ip,
  String[1]                    $password,
  String[1]                    $hostname    = $title,
  Optional[Numeric]            $port        = 9102,
  Optional[String[1]]          $schedule    = 'weekly',
  Optional[Enum['MD5','SHA1']] $signature   = 'MD5',
  Optional[String[1]]          $compression = 'GZIP9',
  Array[Stdlib::Absolutepath]  $fileset     = [],
  Array[String[1]]             $exclude     = [],
) {

  include bacula::director

  $director_service_name = $bacula::director::director_service_name

  $catalog_name = $bacula::director::catalog_name
  $conf_d_dir   = $bacula::director::conf_d_dir
  $client_name  = "${hostname}:fd"
  $fileset_name = "${hostname}-fileset"
  $job_name     = "${hostname}-job"

  concat { "${conf_d_dir}/${hostname}.conf":
    mode   => '0640',
    owner  => 'root',
    group  => 'bacula',
    notify => Service[$director_service_name],
  }

  concat::fragment { "client-config-start-for-${hostname}":
    target  => "${conf_d_dir}/${hostname}.conf",
    content => template("${module_name}/bacula-dir-client-start.erb"),
    order   => '01',
  }

  concat::fragment { "client-config-between-include-exclude-for-${hostname}":
    target  => "${conf_d_dir}/${hostname}.conf",
    content => template("${module_name}/bacula-dir-client-between-include-exclude.erb"),
    order   => '03',
  }

  concat::fragment { "client-config-end-for-${hostname}":
    target => "${conf_d_dir}/${hostname}.conf",
    source => "puppet:///modules/${module_name}/bacula-dir-client-end",
    order  => '05',
  }
}

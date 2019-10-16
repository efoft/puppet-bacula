#
# @summary Creates per client config with client, job and fileset definitions
#
define bacula::server::policy (
  String[1]           $client_name = "${title}:fd",
  Stdlib::Ip::Address $client_addr,
  Numeric             $client_port,
  String[1]           $client_pass,
  String[1]           $schedule     = 'weekly',
  Enum['MD5','SHA1']  $signature    = 'MD5',
  String[1]           $compression  = 'GZIP9',
) {

  include bacula::server
  $catalog_name = $bacula::server::catalog_name
  $fileset_name = "${title}-fileset"
  $job_name     = "${title}-job"

  concat { "${bacula::server::conf_d_dir}/${title}.conf":
    mode    => '0640',
    owner   => 'root',
    group   => 'bacula',
  }

  concat::fragment { "client-config-start-for-${title}":
    target  => "${bacula::server::conf_d_dir}/${title}.conf",
    content => template("${module_name}/bacula-dir-client-start.erb"),
    order   => '01',
  }

  concat::fragment { "client-config-end-for-${title}":
    target  => "${bacula::server::conf_d_dir}/${title}.conf",
    source  => "puppet:///modules/${module_name}/bacula-dir-client-end",
    order   => '04',
  }
}

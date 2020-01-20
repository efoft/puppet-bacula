#
define bacula::server::exclude (
  String $hostname,
  String $path,
) {

  include bacula::server

  concat::fragment { "exclude-path-${path}-for-${hostname}":
    target  => "${bacula::server::conf_d_dir}/${hostname}.conf",
    content => template("${module_name}/bacula-dir-client-exclude-fileset.erb"),
    order   => '04',
  }
}

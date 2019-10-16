#
define bacula::server::include (
  String $hostname,
  String $path,
) {

  include bacula::server

  concat::fragment { "include-path-${path}-for-${hostname}":
    target  => "${bacula::server::conf_d_dir}/${hostname}.conf",
    content => template("${module_name}/bacula-dir-client-include-fileset.erb"),
    order   => '02',
  }
}

#
define bacula::director::include (
  String $hostname,
  String $path,
) {

  include bacula::director

  concat::fragment { "include-path-${path}-for-${hostname}":
    target  => "${bacula::director::conf_d_dir}/${hostname}.conf",
    content => template("${module_name}/bacula-dir-client-include-fileset.erb"),
    order   => '02',
  }
}

#
define bacula::director::exclude (
  String $hostname,
  String $path,
) {

  include bacula::director

  concat::fragment { "exclude-path-${path}-for-${hostname}":
    target  => "${bacula::director::conf_d_dir}/${hostname}.conf",
    content => template("${module_name}/bacula-dir-client-exclude-fileset.erb"),
    order   => '04',
  }
}

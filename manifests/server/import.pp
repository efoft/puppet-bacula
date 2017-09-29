#
class bacula::server::import {

  assert_private('This is private class')

  Bacula::Server::Storage <<| tag == "director-${bacula::server::myname}"|>> {
    notify => Service[$bacula::params::server_service_name],
  }

  Bacula::Server::Client <<| tag == "director-${bacula::server::myname}" |>> {
    notify => Service[$bacula::params::server_service_name],
  }
}

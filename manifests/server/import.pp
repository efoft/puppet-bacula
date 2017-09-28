#
class bacula::server::import {

  Bacula::Server::Storage <| tag == "director-${bacula::server::director_name}"|> {
    notify => Service[$bacula::params::server_service_name],
  }

  Bacula::Server::Client <| tag == "director-${bacula::server::director_name}" |> {
    notify => Service[$bacula::params::server_service_name],
  }
}

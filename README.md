# puppet-bacula
Installs bacula director, storage and client

## Installation
Clone into puppet's modules directory:
```
git clone https://github.com/efoft/puppet-bacula.git bacula
```

## Example of usage
Install bacula director:
```
class { '::bacula::server':
    director_name     => $director_name,
    console_pass      => $console_password,
    storage_pass      => $storage_password,
    dbpass            => $database_password,
    local_client_pass => $client_password,
    restore_dir       => "/tmp/bacula-restores",
  }
```
Install bacula storage:
```
  class { '::bacula::storage':
    director_name => $director_name,
    storage_pass  => $password,
    storage_dir   => '/bacula'
  }
```

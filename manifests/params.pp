class statsd::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'statsd'
      $package_provider = 'npm'
      $config_file = '/etc/statsd.js'
      $config_file_user = 'root'
      $config_file_group = 'root'

      $backend_mysql_package = 'statsd-mysql-backend'
      $backend_mysql_package_provider = 'npm'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}

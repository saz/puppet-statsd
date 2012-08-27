define statsd::backend::statsd (
  $statsd_host,
  $statsd_port,
  $ensure = 'present',
  $config_file = $statsd::params::config_file
) {
  include statsd::params
  Class['statsd::backend'] -> Statsd::Backend::Statsd[$name]

  case $ensure {
    present: {
      $file_ensure = 'file'
    }
    absent: {
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  concat::fragment { "statsd_backend_statsd_${name}":
    ensure  => $file_ensure,
    target  => $config_file,
    content => template("${module_name}/backend/statsd.erb"),
    order   => 10,
  }
}

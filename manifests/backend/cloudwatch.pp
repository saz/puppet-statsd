define statsd::backend::cloudwatch (
  $access_key_id,
  $secret_access_key,
  $region,
  $namespace = undef,
  $metric_name = undef,
  $process_key_for_names = false,
  $ensure = 'present',
  $config_file = $statsd::params::config_file,
) {
  include statsd::params
  Class['statsd::backend'] -> Statsd::Backend::Cloudwatch[$name]

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

  concat::fragment { "statsd_backend_cloudwatch_${name}":
    ensure  => $file_ensure,
    target  => $config_file,
    content => template("${module_name}/backend/cloudwatch.erb"),
    order   => 10,
  }
}
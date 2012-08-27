define statsd::backend::mysql (
  $mysql_host,
  $mysql_user,
  $mysql_password,
  $mysql_database = 'default',
  $mysql_table = 'user_statistic',
  $pattern = '/live\.user.([\w-]+).([\d]+)/',
  $pos_key = 1,
  $pos_id = 2,
  $ensure = 'present',
  $config_file = $statsd::params::config_file,
) {
  include statsd::params
  Class['statsd::backend'] -> Statsd::Backend::Mysql[$name]

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

  concat::fragment { "statsd_backend_mysql_${name}":
    ensure  => $file_ensure,
    target  => $config_file,
    content => template("${module_name}/backend/mysql.erb"),
    order   => 10,
  }
}

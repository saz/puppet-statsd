include nodejs
class { 'statsd': }

statsd::instance { 'test':
  flushInterval => 60000,
  backends      => ['test'],
}

class { 'statsd::backend':
  packages => [ 'mysql' ],
}

statsd::backend::mysql { 'test':
  mysql_host     => '127.0.0.1',
  mysql_user     => 'foo',
  mysql_password => 'bar',
}

include nodejs
class { 'statsd': }

statsd::instance { 'test':
  flushInterval => 60000,
  backends      => ['test'],
}

class { 'statsd::backend':
  packages => [ 'mysql' ],
}

statsd::backend::statsd { 'test':
  statsd_host     => '127.0.0.1',
  statsd_port     => '9090',
}

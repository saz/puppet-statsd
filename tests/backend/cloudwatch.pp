include nodejs
class { 'statsd': }

statsd::instance { 'test':
  flushInterval => 60000,
  backends      => ['test'],
}

class { 'statsd::backend':
  packages => [ 'mysql' ],
}

statsd::backend::cloudwatch { 'test':
  access_key_id         => 'test',
  secret_access_key     => 'test',
  region                => 'US_EAST_1',
  process_key_for_names => true,
}


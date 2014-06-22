include nodejs
class { 'statsd': }

statsd::instance { 'test':
  flushInterval => 60000,
  backends      => ['test'],
}

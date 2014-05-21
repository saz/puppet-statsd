include nodejs
class { 'statsd': }

class { 'statsd::backend':
  packages => [ 'mysql' ],
}

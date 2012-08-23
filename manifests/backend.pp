class statsd::backend (
  $packages,
  $ensure = 'present',
  $autoupgrade = false,
  $package_provider = $statsd::params::package_provider
) inherits statsd::params {
  Class['statsd'] -> Class['statsd::backend']

  validate_array($packages)

  case $ensure {
    present: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'installed'
      }
    }
    absent: {
      $package_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { $packages:
    ensure   => $package_ensure,
    provider => $package_provider,
  }
}

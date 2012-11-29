class statsd (
  $ensure = 'present',
  $autoupgrade = false,
  $package_name = $statsd::params::package_name,
  $package_provider = $statsd::params::package_provider,
) inherits statsd::params {

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

  package { $package_name:
    ensure   => $package_ensure,
    provider => $package_provider,
    require  => Class['nodejs'],
  }
}

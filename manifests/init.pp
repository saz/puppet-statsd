# == Class: statsd
#
# Full description of class statsd here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { statsd:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Steffen Zieger <me@saz.sh>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
define statsd (
  $flushInterval,
  $ensure = present,
  $autoupgrade = false,
  $address = '0.0.0.0',
  $port = 8125,
  $graphiteHost = undef,
  $graphitePort = undef,
  $backends = ['./backends/graphite',],
  $statsd_debug = false,
  $mgmt_address = '0.0.0.0',
  $mgmt_port = 8126,
  $debugInterval = 10000,
  $dumpMessages = false,
  $percentThreshold = 90,
  $log_backend = 'stdout',
  $log_application = 'statsd',
  $log_level = 'LOG_INFO',
  $keyFlush_interval = 0,
  $keyFlush_percent = 100,
  $keyFlush_log = 'STDOUT',
  $console_prettyprint = true,
  $config_file = $statsd::params::config_file,
  $config_file_user = $statsd::params::config_file_user,
  $config_file_group = $statsd::params::config_file_user,
  $package_name = $statsd::params::package_name,
  $package_provider = $statsd::params::package_provider
) {
  include statsd::params {

  case $ensure {
    present: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'installed'
      }

      $file_ensure = 'file'
    }
    absent: {
      $package_ensure = 'absent'
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { $package_name:
    ensure   => $package_ensure,
    provider => $package_provider,
  }

  include concat::setup
  concat { $config_file: }

  concat::fragment { "statsd_base_${name}":
    ensure  => $file_ensure,
    target  => $config_file,
    content => template("${module_name}/statsd.js.erb"),
    order   => 01,
  }

  concat::fragment { "statsd_end_${name}":
    ensure  => $file_ensure,
    target  => $config_file,
    content => "}\n",
    order   => 99,
  }

  #file { $config_file:
  #  ensure  => $file_ensure,
  #  owner   => $config_file_user,
  #  group   => $config_file_group,
  #  mode    => '0644',
  #  content => template("${module_name}/statsd.js.erb"),
  #  require => Package[$package_name],
  #}
}

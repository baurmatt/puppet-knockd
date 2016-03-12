# Class: knockd::init
#
# A class for managing knockd configuration.
#
# Parameters:
# package_name:
#   package name.
#
# service_name:
#   service name (initscript name).
#
# usesyslog:
#   log action messages through syslog().
#
# logfile:
#   log actions directly to a file, (defaults to: /var/log/knockd.log).
#
# pidfile:
#   pidfile to use when in daemon mode, (defaults to: /var/run/knockd.pid).
#
# interface:
#   network interface to listen on (mandatory).
#
# Examples:
#
# class { "knockd":
# 	interface => 'eth0',
# }
#
# Copyright 2015 Alessio Cassibba (X-Drum), unless otherwise noted.
#
class knockd (
	$package_name = $knockd::params::package_name,
	$service_name = $knockd::params::service_name,
	$config_file = $knockd::params::config_file,
	$usesyslog = $knockd::params::usesyslog,
	$logfile = $knockd::params::logfile,
	$pidfile = $knockd::params::pidfile,
	$interface = $knockd::params::interface,
  $sequences = {},
) inherits knockd::params {

	if $interface == undef {
		fail("Please specify a valid interface.")
	}

	if $::osfamily == 'Debian' {
    file_line { 'enable_knockd_startup':
      path   => '/etc/default/knockd',
      line   => 'START_KNOCKD=1',
      match  => 'START_KNOCKD=0',
      before => Service[$knockd::params::service_name],
    }
	}

	package { $knockd::params::package_name:
		ensure => $package_ensure,
	}

	concat { $knockd::params::config_file:
		owner   => $knockd::params::default_owner,
		group   => $knockd::params::default_group,
		mode    => '0740',
	}
	concat::fragment{ 'knockd_config_header':
		target => $knockd::params::config_file,
		content => template('knockd/knockd.conf.erb'),
		order => '00',
	}
	concat::fragment{ 'knockd_config_footer':
		target  => $knockd::params::config_file,
		content => "",
		order   => '99',
	}

	service { $knockd::params::service_name:
		ensure     => 'running',
		enable     => true,
		hasstatus  => false,
		hasrestart => true,
		subscribe  => File[$knockd::params::config_file],
		require    => [Package[$knockd::params::package_name], File[$knockd::params::config_file]],
	}

  create_resources('knockd::sequence', $sequences)
}

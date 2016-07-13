# == Class: knockd::params
#
# A class for managing knockd configuration.
#
# Copyright 2015 Alessio Cassibba (X-Drum), unless otherwise noted.
#
class knockd::params {
	$service_name = 'knockd'
	$usesyslog = undef
	$logfile = '/var/log/knockd.log'
	$pidfile = '/var/run/knockd.pid'
	$interface = undef
	$sequence = undef
	$open_sequence = undef
	$close_sequence = undef
	$one_time_sequences = undef
	$seq_timeout = undef
	$tcpflags = undef
	$start_command = undef
	$stop_command = undef
	$cmd_timeout = undef

	case $::kernel {
		'FreeBSD': {
			$config_file = '/usr/local/etc/knockd.conf'
			$default_owner = 'root'
			$default_group = 'wheel'
			$package_name = 'knock'
		}
		'Linux',default: {
			$config_file = '/etc/knockd.conf'
			$default_owner = 'root'
			$default_group = 'root'
			$package_name = 'knockd'
		}
	}
}

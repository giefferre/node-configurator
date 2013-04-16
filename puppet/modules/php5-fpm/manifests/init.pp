class php5-fpm {
	case $::operatingsystem {
	        "ubuntu": {
	                case $::operatingsystemrelease {
	                        '12.04': {}
	                        '12.10': {}
	                        default: { fail("Module not supported on this release of Ubuntu") }
	                }
	        }
	        default: {
	                fail("Module not supported on this operating system")
	        }
	}

	$phpPackages = [ "php5-cli", "php5-fpm", "php5-sqlite", "php5-curl", "php5-gd", "php5-imagick", "phpunit" ]
	package { $phpPackages: ensure => latest, }

    service { 'php5-fpm':
            ensure => running,
            enable => true,
            hasrestart => true,
            hasstatus => true,
            require => [ Package['nginx'], Package['php5-fpm'], ],
            restart => 'service php5-fpm reload',
    }

	file { 'php-fpm.conf':
			path => '/etc/php5/fpm/php-fpm.conf',
			ensure => file,
			owner => 'root',
			group => 'root',
			mode => '0644',
            notify => Service['php5-fpm'],
            require => Package['php5-fpm'],
            source => 'puppet:///modules/php5-fpm/php-fpm.conf',
            before => File['php-www.conf'],
	}

	file { 'php-www.conf':
			path => '/etc/php5/fpm/pool.d/www.conf',
			ensure => file,
			owner => 'root',
			group => 'root',
			mode => '0644',
            notify => Service['php5-fpm'],
            require => Package['php5-fpm'],
            source => 'puppet:///modules/php5-fpm/www.conf',
	}

}

import '*.pp'
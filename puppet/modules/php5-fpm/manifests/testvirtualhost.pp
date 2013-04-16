define php5-fpm::testvirtualhost () {
    include php5-fpm

	file { '/srv/www/server.test':
		ensure => directory,
		owner => 'root',
		group => 'root',
		mode => '0755',
		before => File['/srv/www/server.test/logs'],
	}

	file { '/srv/www/server.test/logs':
		ensure => directory,
		owner => 'root',
		group => 'root',
		mode => '0755',
		before => File['/srv/www/server.test/application'],
	}

	file { '/srv/www/server.test/application':
		ensure => directory,
		owner => 'www-data',
		group => 'www-data',
		mode => '0775',
		before => File['/srv/www/server.test/application/index.php'],
	}

	file { '/srv/www/server.test/application/index.php':
        path => '/srv/www/server.test/application/index.php',
        ensure => file,
        owner => 'www-data',
        group => 'www-data',
        mode => '0664',
        source => 'puppet:///modules/php5-fpm/index.php',
        before => File['/etc/nginx/sites-available/server.test'],
	}

	file { '/etc/nginx/sites-available/server.test':
		path => '/etc/nginx/sites-available/server.test',
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/php5-fpm/nginx_server.test',
		before => File['/etc/nginx/sites-enabled/server.test'],
	}

	file { '/etc/nginx/sites-enabled/server.test':
		ensure => link,
		target => '/etc/nginx/sites-available/server.test',
		notify => Service['nginx'],
		before => Exec['nginx_reload_after_php5-fpm_testvirtualhost'],
	}

	file { '/etc/logrotate.d/server.test':
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/nginx/logrotate_server.test.conf',
	}

	exec { 'nginx_reload_after_php5-fpm_testvirtualhost':
        command => "/etc/init.d/nginx reload",
    }
}
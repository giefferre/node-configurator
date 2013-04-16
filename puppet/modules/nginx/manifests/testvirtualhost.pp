define nginx::testvirtualhost () {
    include nginx

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
		before => File['/srv/www/server.test/application/index.html'],
	}

	file { '/srv/www/server.test/application/index.html':
        path => '/srv/www/server.test/application/index.html',
        ensure => file,
        owner => 'www-data',
        group => 'www-data',
        mode => '0664',
        source => 'puppet:///modules/nginx/index.html',
        before => File['/etc/nginx/sites-available/server.test'],
	}

	file { '/etc/nginx/sites-available/server.test':
		path => '/etc/nginx/sites-available/server.test',
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/nginx/server.test',
		before => File['/etc/nginx/sites-enabled/server.test'],
	}

	file { '/etc/nginx/sites-enabled/server.test':
		ensure => link,
		target => '/etc/nginx/sites-available/server.test',
		before => File['/etc/logrotate.d/server.test'],
		notify => Service['nginx'],
	}

	file { '/etc/logrotate.d/server.test':
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/nginx/logrotate_server.test.conf',
		before => Exec['nginx_reload_after_nginx_testvirtualhost'],
	}

	exec { 'nginx_reload_after_nginx_testvirtualhost':
        command => "/etc/init.d/nginx reload",
    }
}
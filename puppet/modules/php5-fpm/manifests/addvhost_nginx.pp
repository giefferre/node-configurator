define php5-fpm::addvhost_nginx (
	$website_host = "site.local",
	$website_root = "",
	$config_template = "php5-fpm/nginx.phpdefault.conf.erb"
) {
	include nginx
    include php5-fpm

	file { "/srv/www/${website_host}":
		ensure => directory,
		owner => 'root',
		group => 'root',
		mode => '0755',
		before => File["/srv/www/${website_host}/logs"],
	}

	file { "/srv/www/${website_host}/logs":
		ensure => directory,
		owner => 'root',
		group => 'root',
		mode => '0755',
		before => File["/srv/www/${website_host}/application"],
	}

	file { "/srv/www/${website_host}/application":
		ensure => directory,
		owner => 'www-data',
		group => 'www-data',
		mode => '0775',
		before => File["/srv/www/${website_host}/application/index.php"],
	}

	file { "/srv/www/${website_host}/application/index.php":
        path => "/srv/www/${website_host}/application/index.php",
        ensure => file,
        owner => 'www-data',
        group => 'www-data',
        mode => '0664',
        source => 'puppet:///modules/php5-fpm/info.php',
        before => File["/etc/nginx/sites-available/${website_host}"],
	}

	file { "/etc/nginx/sites-available/${website_host}":
		path => "/etc/nginx/sites-available/${website_host}",
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		require => Package['nginx'],
		content => template("${config_template}"),
		before => File["/etc/nginx/sites-enabled/${website_host}"],
	}

	file { "/etc/nginx/sites-enabled/${website_host}":
		ensure => link,
		target => "/etc/nginx/sites-available/${website_host}",
		notify => Service['nginx'],
		before => Exec["nginx_reload_after_php5-fpm_addvirtualhost-${website_host}"],
	}

	file { "/etc/logrotate.d/${website_host}":
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		content => template("php5-fpm/logrotate.conf.erb"),
	}

	exec { "nginx_reload_after_php5-fpm_addvirtualhost-${website_host}":
        command => "/etc/init.d/nginx reload",
    }

}
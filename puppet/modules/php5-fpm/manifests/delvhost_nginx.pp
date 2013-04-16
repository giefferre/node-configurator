define php5-fpm::delvhost_nginx (
	$website_host = "site.local"
) {
	include nginx

	file { "/etc/logrotate.d/${website_host}":
		ensure => absent,
		force => true,
		before => File["/etc/nginx/sites-enabled/${website_host}"],
	}

	file { "/etc/nginx/sites-enabled/${website_host}":
		ensure => absent,
		force => true,
		notify => Service['nginx'],
		before => File["/etc/nginx/sites-available/${website_host}"],
	}

	file { "/etc/nginx/sites-available/${website_host}":
		path => "/etc/nginx/sites-available/${website_host}",
		ensure => absent,
		force => true,
		before => File["/srv/www/${website_host}"],
	}

	file { "/srv/www/${website_host}":
		ensure => absent,
		force => true,
		before => Exec["nginx_reload_after_php5-fpm_delvirtualhost-${website_host}"],
	}

	exec { "nginx_reload_after_php5-fpm_delvirtualhost-${website_host}":
        command => "/etc/init.d/nginx reload",
    }

}
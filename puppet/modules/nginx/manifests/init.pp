class nginx {
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
        
        package { 'nginx':
                ensure => latest,
                provider => apt,
        }

        service { 'nginx':
                ensure => running,
                enable => true,
                hasrestart => true,
                hasstatus => true,
                require => Package['nginx'],
                restart => '/etc/init.d/nginx reload',
        }

        file { 'nginx-disable-default':
                path => '/etc/nginx/sites-enabled/default',
                ensure => absent,
                notify => Service['nginx'],
                require => Package['nginx'],
        }

        file { 'nginx-conf':
                path => '/etc/nginx/nginx.conf',
                ensure => file,
                owner => 'root',
                group => 'root',
                mode => '0644',
                notify => Service['nginx'],
                require => Package['nginx'],
                source => 'puppet:///modules/nginx/nginx.conf',
                before => File['srv-www'],
        }

        file { 'srv-www':
                path => '/srv/www',
                ensure => directory,
                owner => 'root',
                group => 'root',
                mode => '0755',
        }

}

import '*.pp'
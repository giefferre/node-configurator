class mysql-server {
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
     
    package { "MySQL-client": ensure => latest }
    package { "MySQL-server": ensure => latest }
    package { "MySQL-shared": ensure => latest }

}

import '*.pp'
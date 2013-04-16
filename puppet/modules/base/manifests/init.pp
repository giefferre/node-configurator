class base {
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
        
    $sysPackages = ["build-essential", "curl", "language-pack-en", "wget", "git", "sqlite", "python", "python-dev", "python-setuptools", "python-pip"]
	package { $sysPackages: ensure => latest, }

}

import '*.pp'
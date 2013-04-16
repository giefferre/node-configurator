define mysql-server::setpassword (
    $password = "mysql123root456password",
) {
    include mysql-server
    exec { "Set MySQL server root password":
        subscribe => [ Package["MySQL-server"], Package["MySQL-client"], Package["MySQL-shared"] ],
        refreshonly => true,
        unless => "mysqladmin -uroot -p$password status",
        path => "/bin:/usr/bin",
        command => "mysqladmin -uroot password $password",
    }    
}
class samba::install {

	$samba_client =  ['samba-common'] 
	package { $samba_client:
		ensure => present,
	}
}

class samba::service {

    case $operatingsystem { 
		CentOS,RedHat: { $servicename = "smb" }
		Debian,Ubuntu: { $servicename = "smbd" }
	}
    service { "$servicename":
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Class["samba::install"],
    }
}

class samba {
    include samba::install
}

class samba::server {

    include samba
    include samba::install
    include samba::service

	$sambapackages =  ['samba'] 
	package { $sambapackages:
		ensure => present,
	}

    File {
        owner   => root,
        group   => root,
        mode    => 0644,
    }

    define config ( $source = '' , $content = '' ) {

        # Debian/Ubuntu/Centos/Redhat are all using the same config file, it's zomg incredible
        $configfile = "/etc/samba/smb.conf"

        if($source != '') and ($content == '' ) {
            file { "$configfile":
                source => $source,
                require => Package["$sambapackages"],
                notify  => Service["$samba::service::servicename"],
            }
        } 
        if($content != '') and ($source == '' ) {
            file { "$configfile":
                content => $content,
                require => Package["$sambapackages"],
                notify  => Service["$samba::service::servicename"],
            }
        } 
    }

}


# vmware.pp
# Install VMware Workstation Player for OS X, Ubuntu, or Windows
# https://www.vmware.com/products/workstation-player.html
#
#

class software::virtualization::vmware (
  $ensure  = $software::params::software_ensure,
  $version = $software::params::vmware_version,
  $urlbase = $software::params::vmware_urlbase,
  $package = $software::params::vmware_package,
) inherits software::params {

  validate_string($ensure)

  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      validate_string($version, $urlbase, $package)

      $vmware_installer = "/tmp/${package}"
      $vmware_install_cmd = "${vmware_installer} --console --eulas-agreed --required"
      $vmware_uninstall_cmd = "${vmware_installer} --uninstall-product=vmware-player --required"

      file { $vmware_installer:
        source => "${urlbase}/${package}",
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
      -> exec { $vmware_install_cmd:
        path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
        # NOTE: This will make it difficult to upgrade to a newer version
        # (VMware-Player will need to be uninstalled prior to upgrade)
        creates => '/usr/bin/vmplayer',
      }
    }
    default: {
      fail("The ${name} class is not supported on ${::operatingsystem}.")
    }
  }

}

# pdk.pp
# Install Puppet Development Kit
# https://puppet.com/download-puppet-development-kit
#

class software::idesdk::pdk (
  $ensure  = $software::params::software_ensure,
  $version = $software::params::pdk_version,
  $url     = $software::params::pdk_url,
) inherits software::params {

  validate_string($ensure)

  case $::operatingsystem {
    'Ubuntu': {
      package { 'pdk':
        ensure   => $ensure,
        source   => '/tmp/pdk.deb',
        provider => 'dpkg',
      }

      file { '/tmp/pdk.deb':
        source  => $url,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        before => Package['pdk'],
      }
    }
    default: {
      fail("The ${name} class is not supported on ${::operatingsystem}.")
    }
  }

}

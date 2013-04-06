# == Class: sabnzbd
#
# Full description of class sabnzbd here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#
# === Examples
#
#  class { sabnzbd:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Andrew Harley <morphizer@gmail.com>
#
class sabnzbd {

  # on ubuntu it's available in official repositories since jaunty
  package { 'sabnzbdplus':
    ensure  => installed,
  }

  package { 'sabnzbdplus-theme-mobile':
    ensure  => installed,
    require => Package['sabnzbdplus'],
  }

  package { 'sabnzbdplus-theme-smpl':
    ensure  => installed,
    require => Package['sabnzbdplus'],
  }

}

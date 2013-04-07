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
class sabnzbd (
  $user           = $::sabnzbd::params::user,
  $config_path    = $::sabnzbd::params::config_path,
  $host           = $::sabnzbd::params::host,
  $port           = $::sabnzbd::params::port,
  $extraopts      = undef,
  $enable_https   = $::sabnzbd::params::enable_https,
  $https_port     = $::sabnzbd::params::9190,
  $api_key        = $::sabnzbd::params::api_key,
  $nzb_key        = $::sabnzbd::params::nzb_key,
  $download_dir   = $::sabnzbd::params::download_dir,
  $complete_dir   = $::sabnzbd::params::complete_dir,
  $login_username = $::sabnzbd::params::login_username,
  $login_password = $::sabnzbd::params::login_password,
  $servers        = {}
) inherits sabnzbd::params {

  if $servers == undef { fail('Please define news servers') }

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

  user { $::sabnzbd::params::user:
    ensure     => present,
    comment    => 'SABnzbd user, created by Puppet',
    system     => true,
    managehome => true,
    require    => Package['sabnzbdplus'],
  }

  file { '/etc/default/sabnzbdplus':
    ensure  => file,
    require => Package['sabnzbdplus'],
    content => template('sabnzbd/sabnzbdplus.erb'),
  }

  file { $config_path:
    ensure  => file,
    require => Package['sabnzbdplus'],
    content => template('sabnzbd/sabnzbd.ini.erb'),
  }
}

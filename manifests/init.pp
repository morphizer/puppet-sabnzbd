# == Class: sabnzbd
#
# This class installs and configures sabnzbd.
#
# === Parameters
#
# [*user*]
#   Specify the user to run sickbeard as. The user will be automatically
#   created. Defaults to "sabnzbd".
# [*config_path*]
#   Full path to the config file to use. Defaults to sabnzbd user's home
#   directory.
# [*host*]
#   The IP address sabnzbd should listen on. Defaults to 0.0.0.0
# [*port*]
#   Port to listen on. Defaults to 8180.
# [*extraopts*]
#   An optional set of parameters to pass to the daemon
# [*enable_https*]
#   Set to 1 to enable https. Defaults to 0 (disabled)
# [*https_port*]
#   https port to use if enabled. Defaults to 9190.
# [*api_key*]
#   Set the api key to use. A default key is used.
# [*nzb_key*]
#   API key for just nzb interactions.
# [*download_dir*]
#   Temporary download location. Defaults to /home/sabnzbd/Downloads/incomplete
# [*complete_dir*]
#   Completed download location. Defaults to /home/sabnzbd/Downloads/complete
# [*login_username*]
#   Username to use for password protection of sabnzbd. Default is none.
# [*login_password*]
#   Password to use for password protection of sabnzbd. Default is none.
# [*servers*]
#   A user supplied hash of usenet servers to connect to. *required*
# [*categories*]
#   A user supplied hash of an optional set of categories to setup
#
# === Variables
#
# [*unrar*]
#   The package to select for unraring files. unrar-free on debian is used,
#   but this has problems with some RAR files. Will add a PPA in future.
#
# === Examples
#
#  $servers = {
#    myprovider => { 'server_url'  => 'news.provider1.com',
#                    'port'        => '119',
#                    'connections' => '10',
#    },
#    backup => { 'server_url'  => 'news.provider2.com',
#                'port'        => '119',
#                'connections' => '5',
#                'backup_server' => '1',
#     }
#  }
#
#  $categories = {
#    tv     => { 'directory' => 'TV' },
#    movies => { 'directory' => '/opt/share/movies' },
#  }
#
#  class { 'sabnzbd':
#    servers  => $servers,
#    categories => $categories,
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
  $https_port     = $::sabnzbd::params::https_port,
  $api_key        = $::sabnzbd::params::api_key,
  $nzb_key        = $::sabnzbd::params::nzb_key,
  $download_dir   = $::sabnzbd::params::download_dir,
  $complete_dir   = $::sabnzbd::params::complete_dir,
  $login_username = $::sabnzbd::params::login_username,
  $login_password = $::sabnzbd::params::login_password,
  $servers        = {},
  $categories     = {}
) inherits sabnzbd::params {

  # make it run apt-get update first
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }
  
  Exec["apt-update"] -> Package <| |>

  # on ubuntu it's available in official repositories since jaunty
  # though it's an old version. Will add the custom ppa soon.
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

  # We also require the unrar program
  $unrar = $::operatingsystem ? {
    'Debian' => 'unrar-free',
    default  => 'unrar',
  }
  package { $unrar: ensure => installed }

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
    notify  => Service['sabnzbdplus'],
  }

  file { $config_path:
    ensure  => file,
    require => Package['sabnzbdplus'],
    content => template('sabnzbd/sabnzbd.ini.erb'),
    notify  => Service['sabnzbdplus'],
    owner   => $user,
    group   => $user
  }

  service { 'sabnzbdplus':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['sabnzbdplus'],
  }
}

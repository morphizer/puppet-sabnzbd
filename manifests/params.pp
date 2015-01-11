# == Class: sabnzbd::params
#
# Provides some sane default settings for getting started with
# sabnzbd.
class sabnzbd::params {

  # These settings allow sabnzbd to start
  $user        = 'sabnzbd'
  $config_path = '/home/sabnzbd/sabnzbd.ini'
  $host        = '0.0.0.0'
  $port        = '8180'

  # General configuration settings
  $enable_https = '0'
  $https_port   = '9190' # only used if above is true
  $api_key      = '155afa0330c150972ce3c6efe2d59533'
  $nzb_key      = 'b9606ae4f0424a23aad94f1a30cc5b8d'
  $download_dir = 'Downloads/incomplete'
  $complete_dir = 'Downloads/complete'

  # Login settings for sabnzbd frontend, blank means no login
  $login_username     = ''
  $login_password     = ''

  # Theme settings
  $web_dir    = 'Plush'
  $web_color  = '""'
  $web_dir2   = '""'
  $web_color2 = '""'

  $permissions = '""'
}

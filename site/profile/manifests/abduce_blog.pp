class profile::abduce_blog {

  $proxy_port = '80'

  include nginx

  nginx::resource::vhost { "_":
    ensure         => present,
    listen_port    => $proxy_port,
    listen_options => 'default',
    www_root       => '/var/www/abduce',
    require        => File['/var/www/abduce'],
  }

  file { ['/var/www', '/var/www/abduce']:
    ensure  => directory,
    owner   => 'nginx',
    group   => 'nginx',
    mode    => '755',
    require => Package['nginx'],
  }

  $content_repo_owner = 'kjhenner'
  $content_repo_name  = 'abduce'
  $content_repo_dir   = "/usr/src/${content_repo_name}"

  # Install jekyll
  package { 'jekyll':
    ensure   => present,
    provider => 'gem',
  }

  vcsrepo { $content_repo_dir:
    ensure   => present,
    provider => git,
    revision => 'master',
    source   => "git://github.com/${content_repo_owner}/${content_repo_name}.git",
  }

}

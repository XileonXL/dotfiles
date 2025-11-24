name 'workstation'
maintainer 'Your Name'
maintainer_email 'your.email@example.com'
license 'All Rights Reserved'
description 'Manages dotfiles, package installations, and application configurations across multiple platforms'
version '0.1.0'
chef_version '>= 15.0'

# Supported platforms
supports 'arch'
supports 'ubuntu'
supports 'mac_os_x'

# Issues and source repository
issues_url 'https://github.com/yourusername/chef-dotfiles/issues' if respond_to?(:issues_url)
source_url 'https://github.com/yourusername/chef-dotfiles' if respond_to?(:source_url)

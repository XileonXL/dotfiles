# Chef Client Configuration for Local Mode
# This configuration enables chef-zero for local development and testing

# Enable local mode (chef-zero)
local_mode true

# Set the cookbook path relative to the repository root
current_dir = File.dirname(__FILE__)
cookbook_path File.expand_path('../cookbooks', current_dir)

# Cache and log paths
cache_path File.expand_path('../.chef/local-mode-cache', current_dir)
log_location STDOUT
log_level :info

# Disable SSL verification for local mode (optional, uncomment if needed)
# ssl_verify_mode :verify_none

# Chef Zero configuration
# chef_zero.enabled true

# Optionally set a node name (useful for testing)
# node_name 'workstation-local'

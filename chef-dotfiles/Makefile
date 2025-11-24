# Makefile for Chef Dotfiles Repository
# Provides convenient shortcuts for common Chef operations

.PHONY: help apply test clean status check-deps

# Default target
help:
	@echo "Chef Dotfiles Management"
	@echo ""
	@echo "Available targets:"
	@echo "  help       - Show this help message"
	@echo "  check-deps - Check if Chef Workstation is installed"
	@echo "  test       - Run chef-client in why-run mode (dry-run)"
	@echo "  apply      - Apply the configuration (may require sudo)"
	@echo "  apply-sudo - Apply the configuration with sudo"
	@echo "  status     - Show what would change (same as test)"
	@echo "  clean      - Remove local cache"
	@echo ""

# Check dependencies
check-deps:
	@echo "Checking for Chef Workstation..."
	@which chef-client > /dev/null 2>&1 || (echo "ERROR: chef-client not found. Please install Chef Workstation." && exit 1)
	@echo "Chef Workstation is installed:"
	@chef-client --version

# Test configuration (dry run)
test:
	@echo "Running Chef in why-run mode (no changes will be made)..."
	chef-client -z --why-run -o 'recipe[workstation::default]'

# Alias for test
status: test

# Apply configuration
apply:
	@echo "Applying Chef configuration..."
	chef-client -z -o 'recipe[workstation::default]'

# Apply configuration with sudo
apply-sudo:
	@echo "Applying Chef configuration with elevated privileges..."
	sudo chef-client -z -o 'recipe[workstation::default]'

# Clean local cache
clean:
	@echo "Cleaning local Chef cache..."
	rm -rf .chef/local-mode-cache
	@echo "Cache cleaned."

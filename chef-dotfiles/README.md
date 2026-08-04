# Chef Dotfiles Repository

A Chef Infra-based repository for managing dotfiles, package installations, and application configurations across multiple operating systems.

## Purpose

This repository provides a centralized, version-controlled approach to managing workstation configurations using Chef Infra. It replaces the previous Ansible-based system with a robust Chef implementation that supports multiple platforms.

### Key Features

- **Multi-platform support**: ArchLinux, Ubuntu, and macOS
- **Local mode operation**: No Chef Server required
- **Reproducible configurations**: Consistent environment across machines
- **Version controlled**: Track changes to your dotfiles and configurations
- **Modular design**: Easy to extend and customize

## Supported Operating Systems

- **ArchLinux** (Arch Linux)
- **Ubuntu** (All current LTS and recent versions)
- **macOS** (Mac OS X)

## Prerequisites

Before using this repository, ensure you have Chef Infra Client installed:

### Installation

**macOS (using Homebrew):**
```bash
brew install chef/chef/chef-workstation
```

**Ubuntu/Debian:**
```bash
wget https://packages.chef.io/files/stable/chef-workstation/latest/ubuntu/22.04/chef-workstation_latest_amd64.deb
sudo dpkg -i chef-workstation_latest_amd64.deb
```

**Arch Linux:**
```bash
yay -S chef-workstation
# or
pamac install chef-workstation
```

**Alternative (Universal):**
```bash
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef-workstation
```

## Repository Structure

```
chef-dotfiles/
├── .chef/
│   ├── config.rb              # Chef client configuration
│   └── local-mode-cache/      # Local cache directory (auto-generated)
├── cookbooks/
│   └── workstation/           # Main workstation cookbook
│       ├── attributes/        # Default attributes
│       ├── files/             # Static files to deploy
│       ├── recipes/           # Recipe files
│       │   └── default.rb     # Main recipe
│       ├── templates/         # ERB templates
│       └── metadata.rb        # Cookbook metadata
└── README.md                  # This file
```

## Usage

### Running Chef in Local Mode

Chef Infra Client can run in local mode (chef-zero) without requiring a Chef Server. This is the primary mode for this repository.

#### Basic Execution

From the repository root, run:

```bash
cd chef-dotfiles
chef-client --local-mode --config .chef/config.rb --override-runlist 'recipe[workstation::default]'
```

#### Simplified Command (After Configuration)

Once configured, you can use a shorter command:

```bash
chef-client -z -o 'recipe[workstation::default]'
```

Where:
- `-z` is short for `--local-mode`
- `-o` is short for `--override-runlist`

#### Running with Specific Log Level

```bash
chef-client -z -l debug -o 'recipe[workstation::default]'
```

### Testing Configuration (Dry Run)

To see what changes would be made without applying them:

```bash
chef-client -z --why-run -o 'recipe[workstation::default]'
```

## Development Workflow

### 1. Clone or Initialize Repository

```bash
git clone <repository-url> chef-dotfiles
cd chef-dotfiles
```

### 2. Modify Recipes

Edit the recipes in `cookbooks/workstation/recipes/` to add your configurations:

```bash
vim cookbooks/workstation/recipes/default.rb
```

### 3. Test Changes Locally

```bash
chef-client -z --why-run -o 'recipe[workstation::default]'
```

### 4. Apply Changes

```bash
sudo chef-client -z -o 'recipe[workstation::default]'
```

Note: `sudo` may be required for system-level changes (package installation, system files, etc.)

### 5. Commit Changes

```bash
git add .
git commit -m "Description of changes"
git push
```

## Extending the Repository

### Adding New Recipes

Create new recipe files in `cookbooks/workstation/recipes/`:

```bash
touch cookbooks/workstation/recipes/vim.rb
```

Then include it in the run list:

```bash
chef-client -z -o 'recipe[workstation::default],recipe[workstation::vim]'
```

### Using Templates

Place ERB templates in `cookbooks/workstation/templates/`:

```bash
touch cookbooks/workstation/templates/bashrc.erb
```

Reference them in your recipes:

```ruby
template "#{ENV['HOME']}/.bashrc" do
  source 'bashrc.erb'
  owner ENV['USER']
  mode '0644'
end
```

### Managing Files

Place static files in `cookbooks/workstation/files/`:

```bash
cp ~/.gitconfig cookbooks/workstation/files/default/gitconfig
```

Deploy them in recipes:

```ruby
cookbook_file "#{ENV['HOME']}/.gitconfig" do
  source 'gitconfig'
  owner ENV['USER']
  mode '0644'
end
```

## Platform-Specific Configuration

The cookbook supports platform-specific logic. Example:

```ruby
case node['platform']
when 'arch'
  package 'pacman-package-name'
when 'ubuntu'
  package 'apt-package-name'
when 'mac_os_x'
  package 'brew-package-name'
end
```

## Troubleshooting

### Permission Errors

If you encounter permission errors, run with `sudo`:

```bash
sudo chef-client -z -o 'recipe[workstation::default]'
```

### Cache Issues

Clear the local cache if you experience issues:

```bash
rm -rf .chef/local-mode-cache
```

### Verbose Output

Run with debug logging for more information:

```bash
chef-client -z -l debug -o 'recipe[workstation::default]'
```

## Migration from Ansible

This repository replaces the previous Ansible-based configuration system. Key differences:

- **Paradigm**: Declarative resource-based (Chef) vs. procedural task-based (Ansible)
- **Execution**: Local chef-zero vs. SSH-based execution
- **Idempotency**: Built-in resource convergence vs. manual idempotency checks
- **Platform support**: Native multi-platform resources

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly on target platforms
4. Submit a pull request

## License

All Rights Reserved

## Resources

- [Chef Documentation](https://docs.chef.io/)
- [Chef Resources Reference](https://docs.chef.io/resources/)
- [Chef Infra Client](https://docs.chef.io/chef_client/)
- [Chef Local Mode](https://docs.chef.io/ctl_chef_client/#run-in-local-mode)

## Maintainer

Your Name <your.email@example.com>

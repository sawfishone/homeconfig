# HomeConfig

HomeConfig is a tool for managing configuration files (dotfiles), designed to address the issue of configuration differences across various environments. Unlike traditional tools like Stow, HomeConfig uses Ruby's ERB template engine to dynamically generate configuration files based on different environment variables. Additionally, the project integrates Git for version control, allowing for unified management and tracking of changes to configuration files.

## Key Features

- **Environment Awareness**: Generates configuration files tailored to the current environment based on different system variables like OS, DPI settings, etc.
- **Template-Based Configuration**: Utilizes ERB templates, allowing the inclusion of Ruby code within configuration files to generate dynamic content.
- **Git Version Control**: Manages configuration files via Git, enabling easy tracking of changes, rolling back to previous versions, and syncing configurations across devices.
- **Flexibility**: Easily adapts to different use cases through environment variable configuration without requiring manual changes to the configuration files.

## Installation

To get started with HomeConfig, you need to install Ruby and the ERB gem on your system.

1. **Install Ruby**:
   - On macOS:

     ```bash
     brew install ruby
     ```

   - On Linux: Refer to your distribution's package manager or check the [official Ruby installation guide](https://www.ruby-lang.org/en/documentation/installation/).

2. **Install the ERB gem**:

   ```bash
   gem install erb
   ```

## Usage

HomeConfig provides the `hc` command with the following subcommands:

### Subcommands

- **init**: Initializes the `~/.mydotfiles` directory and creates the initial `user_vars.yaml` configuration file.
- **deploy**: Parses and deploys template files to the target location. Only files with the .erb extension will be parsed as templates, while others will be copied directly.

    ```bash
    hc deploy zsh ~/       # Deploys ~/.mydotfiles/zsh/.zshrc.erb to ~/.zshrc
    hc deploy vim ~/.vim   # Deploys files from ~/.mydotfiles/vim/ directory and its subdirectories to ~/.vim/
    ```

### Template Variables File (`user_vars.yaml`)

Variables such as operating system, DPI, etc., are set in the `~/.mydotfiles/user_vars.yaml` file. These variables are used to dynamically generate configuration files.

```yaml
config:
  os: macOS
  dpi: 222
```

### Template Example (.zshrc.erb)

Here is a .zshrc.erb template example that generates different configuration content based on the value of config.os:

```bash
<% if config.os == 'Linux' %>
# Linux-specific settings
export PATH="$PATH:/usr/local/bin"
<% elsif config.os == 'macOS' %>
# macOS-specific settings
export PATH="$PATH:/opt/homebrew/bin"
<% end %>
```

---
For Chinese documentation, see [README_CN.md](./README_CN.md).

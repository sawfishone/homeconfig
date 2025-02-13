# homeconfig

HomeConfig 是一个用于管理配置文件（dotfiles）的工具，旨在解决不同环境下配置文件差异的问题。与传统的 Stow 管理方式不同，HomeConfig 使用 Ruby 的 ERB 模板引擎，能够根据不同的环境变量动态生成配置文件。同时，项目结合 Git 进行版本控制，方便统一管理和追踪配置文件的变更。

## 主要特点

- **环境感知**：根据不同的操作系统、DPI 设置等环境变量，生成适合当前环境的配置文件。
- **模板化配置**：使用 ERB 模板语言，允许在配置文件中嵌入 Ruby 代码，实现动态内容生成。
- **Git 版本控制**：通过 Git 统一管理配置文件，方便追踪变更、回滚历史版本以及跨设备同步配置。

## 安装

要开始使用 HomeConfig，你需要在系统上安装 Ruby 和 ERB gem。

1. **安装 Ruby**：
   - 在 macOS 上：

        ```bash
        brew install ruby
        ```

   - 在 Linux 上：请参考你的发行版的包管理器，或查看[官方 Ruby 安装指南](https://www.ruby-lang.org/zh/documentation/installation/)。

2. **安装 ERB gem**：

    ```bash
    gem install erb
    ```

## 使用

HomeConfig 提供了 `hc` 命令，并支持子命令。

### 子命令

- **init**：初始化 `~/.mydotfiles` 目录，并创建初始的 `user_vars.yaml` 配置文件。
- **deploy**: 解析并部署模板文件到目标位置。只有扩展名为 .erb 的文件会进行模板解析，其他文件将直接复制。

    ```bash
    hc deploy zsh ~/       # 将 ~/.mydotfiles/zsh/.zshrc.erb 部署为 ~/.zshrc
    hc deploy vim ~/.vim   # 将 ~/.mydotfiles/vim/目录及子目录下的文件部署到 ~/.vim/
    ```

### 模板变量文件（user_vars.yaml）

在 `~/.mydotfiles/user_vars.yaml` 中设置变量（如操作系统、DPI 等）。模板会使用这些变量来动态生成配置文件。

```yaml
config:
  os: macOS
  dpi: 222
```

### 模板示例（.zshrc.erb）

这是一个 .zshrc.erb 模板示例，根据 config.os 的值生成不同的配置内容：

```bash
<% if config.os == 'Linux' %>
# Linux-specific settings
export PATH="$PATH:/usr/local/bin"
<% elsif config.os == 'macOS' %>
# macOS-specific settings
export PATH="$PATH:/opt/homebrew/bin"
<% end %>
```

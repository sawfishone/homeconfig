# lib/commands/init.rb
require "yaml"
require "fileutils"

module Homeconfig
  module Commands
    class Init
      def self.run(_options)
        dotfile_dir = Homeconfig::Dotfile::Path.get_dotfile_dir(nil)
        user_vars_file = File.join(dotfile_dir, "user_vars.yaml")
        gitignore_file = File.join(dotfile_dir, ".gitignore")

        if Dir.exist?(dotfile_dir)
          puts "Directory already exists: #{dotfile_dir}"
        else
          # 创建 ~/.mydotfiles 目录
          FileUtils.mkdir_p(dotfile_dir)
          puts "Created directory: #{dotfile_dir}"
        end

        # 生成初始的 user_vars.yaml 文件
        initial_user_vars = {
          "config" => {
            "os" => "Linux",
            "hostname" => `hostname`.chomp,
            "dpi" => 96,
            "email" => "user@example.com",
          },
        }

        if !File.exist?(user_vars_file)
          # Write the YAML data to user_vars.yaml
          File.write(user_vars_file, YAML.dump(initial_user_vars))
          puts "Created initial user_vars.yaml: #{user_vars_file}"
        end

        if !File.exist?(gitignore_file)
          # Create the .gitignore file and add user_vars.yaml to it
          File.open(gitignore_file, "w") do |file|
            file.puts "user_vars.yaml"
          end
          puts "Created .gitignore and added user_vars.yaml to it: #{gitignore_file}"
        end
      end

      def self.help
        puts "Usage: hc init"
        puts ""
        puts "  Initialize the ~/.mydotfiles directory and create an initial user_vars.yaml file."
        puts ""
        puts "Examples:"
        puts "  hc init  # Create ~/.mydotfiles and generate user_vars.yaml"
      end
    end
  end
end

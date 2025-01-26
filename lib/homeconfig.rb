# lib/homeconfig.rb
require_relative "dotfile/path"
require_relative "commands/edit"
require_relative "commands/deploy"
require_relative "commands/init"

module Homeconfig
  class CLI
    def self.start(args)
      command = args.shift
      options = args
      case command
      when "edit"
        Commands::Edit.run(options)
      when "deploy"
        Commands::Deploy.run(options)
      when "init"
        Commands::Init.run(options)
      else
        help
      end
    end

    def self.help
      puts "Usage: hc <command> <package> [options]"
      puts ""
      puts "Commands:"
      puts "  edit    Edit configuration files for a specific package (e.g., vim, emacs)."
      puts "  deploy  Deploy configuration files for a specific package to the target directory."
      puts "  init    Initialize the ~/.mydotfiles directory and create an initial user_vars.yaml file." # 新增
      puts ""
      puts "Examples:"
      puts "  hc edit vim       # Edit vim configuration files"
      puts "  hc deploy emacs   # Deploy emacs configuration files to the default directory"
      puts "  hc init           # Initialize ~/.mydotfiles and generate user_vars.yaml"
      puts ""
      puts "For more information about a specific command, run:"
      puts "  hc <command> --help"
    end
  end
end

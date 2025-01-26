module Homeconfig
  module Commands
    class Edit
      def self.run(options)
        if options.empty?
          help
          return
        end

        package = options.shift
        package_dir = Homeconfig::Dotfile::Path.get_dotfile_dir(package)

        unless Dir.exist?(package_dir)
          puts "Error: Configuration package '#{package}' does not exist."
          puts "Available packages: #{available_packages.join(", ")}" if available_packages.any?
          return
        end

        editor = select_editor
        open_editor(editor, package_dir)
      end

      def self.help
        puts "Usage: hc edit <package>"
        puts ""
        puts "  Edit configuration files for a specific package (e.g., vim, emacs)."
        puts ""
        puts "Options:"
        puts "  <package>  Name of the configuration package to edit (e.g., vim, emacs)."
        puts ""
        puts "Examples:"
        puts "  hc edit vim    # Edit vim configuration files"
        puts "  hc edit emacs  # Edit emacs configuration files"
      end

      private

      # 获取可用的配置包列表
      def self.available_packages
        dotfile_dir = Homeconfig::Dotfile::Path.get_dotfile_dir(nil)
        Dir.children(dotfile_dir).select { |dir| File.directory?(File.join(dotfile_dir, dir)) }
      end

      # 选择编辑器
      def self.select_editor
        ENV["EDITOR"] || "vim"
      end

      # 打开编辑器
      def self.open_editor(editor, package_dir)
        success = system(editor, package_dir)
        unless success
          puts "Error: Failed to open editor '#{editor}' for package directory '#{package_dir}'."
        end
      end
    end
  end
end

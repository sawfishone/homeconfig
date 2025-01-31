require "yaml"
require "erb"
require "fileutils"
require "ostruct"

module Homeconfig
  module Commands
    class Deploy
      PACKAGE_MAPPING_FILE = File.expand_path("../../config/packages_mapping.yaml", __dir__)

      def self.run(options)
        if options.empty?
          help
          return
        end

        force = options.delete("-f")
        package = options.shift
        target_dir = options.first || mappings[package]

        unless target_dir
          puts "No mapping found for package '#{package}'"
          puts "Available packages: #{available_packages.join(", ")}" if available_packages.any?
          return
        end

        target_dir = replace_env_variables(target_dir)
        FileUtils.mkdir_p(target_dir)

        user_vars = load_user_vars
        return unless user_vars

        package_dir = Homeconfig::Dotfile::Path.get_dotfile_dir(package)
        deploy_files(package_dir, target_dir, user_vars, force)
      end

      def self.help
        puts "Usage: hc deploy <package> [target directory] [-f]"
        puts ""
        puts "  Deploy configuration files for a specific package (e.g., vim, emacs) to the target directory."
        puts ""
        puts "Options:"
        puts "  <package>         Name of the configuration package to deploy (e.g., vim, emacs)."
        puts "  [target directory] Optional target directory to deploy the configuration files."
        puts "  -f                Force overwrite existing files in the target directory."
        puts ""
        puts "Examples:"
        puts "  hc deploy vim ~/.vim    # Deploy vim configuration files to ~/.vim"
        puts "  hc deploy emacs         # Deploy emacs configuration files to the default directory"
        puts "  hc deploy zsh -f        # Force deploy zsh configuration files to the default directory"
      end

      private

      def self.mappings
        @mappings ||= begin
            if File.exist?(PACKAGE_MAPPING_FILE)
              YAML.load_file(PACKAGE_MAPPING_FILE)["packages"] || {}
            else
              {}
            end
          end
      end

      def self.load_user_vars
        user_vars_file = File.join(Homeconfig::Dotfile::Path.get_dotfile_dir(nil), "user_vars.yaml")
        if File.exist?(user_vars_file)
          YAML.load_file(user_vars_file)
        else
          puts "Error: User variables file not found at #{user_vars_file}. Please ensure it exists."
          nil
        end
      end

      def self.deploy_files(package_dir, target_dir, user_vars, force)
        Dir.glob(File.join(package_dir, "**", "*")).each do |full_path|
          next if File.directory?(full_path)

          relative_path = full_path.sub("#{package_dir}/", "")
          output_file = File.join(target_dir, relative_path.gsub(/\.erb$/, ""))

          if full_path.end_with?(".erb")
            deploy_erb_file(full_path, output_file, user_vars, force)
          else
            deploy_plain_file(full_path, output_file, force)
          end
        end
      end

      def self.deploy_erb_file(source, destination, user_vars, force)
        template = ERB.new(File.read(source))
        config = OpenStruct.new(user_vars["config"])
        result = template.result(binding)
        write_file(destination, result, force)
      rescue => e
        puts "Error processing ERB file #{source}: #{e.message}"
      end

      def self.deploy_plain_file(source, destination, force)
        write_file(destination, File.read(source), force)
      rescue => e
        puts "Error copying file #{source}: #{e.message}"
      end

      def self.write_file(destination, content, force)
        if File.exist?(destination) && !force
          puts "File exists and will not be overwritten: #{destination}"
          return
        end
        FileUtils.mkdir_p(File.dirname(destination))
        File.write(destination, content)
        puts "Processed and copied: #{destination}"
      end

      def self.replace_env_variables(str)
        str.gsub(/\$\{?([A-Za-z_][A-Za-z0-9_]*)\}?/) { ENV[$1] }
      end

      def self.available_packages
        dotfile_dir = Homeconfig::Dotfile::Path.get_dotfile_dir(nil)
        Dir.children(dotfile_dir).select { |dir| File.directory?(File.join(dotfile_dir, dir)) }
      end
    end
  end
end

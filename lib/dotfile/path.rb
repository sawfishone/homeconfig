module Homeconfig
  module Dotfile
    class Path
      # 默认工作目录
      DEFAULT_MYDOTFILES_DIR = File.join(ENV["HOME"], ".mydotfiles")

      # 获取工作目录或指定包的路径
      def self.get_dotfile_dir(package = nil)
        mydotfiles_dir = ENV["MYDOTFILES_DIR"] || DEFAULT_MYDOTFILES_DIR
        if package
          package_dir = File.join(mydotfiles_dir, package.to_s)
          package_dir
        else
          mydotfiles_dir
        end
      end

    end
  end
end

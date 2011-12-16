require 'find'
class Bolts < Thor::Group
  include Thor::Actions

  argument :group, :default => "", :desc => "leave blank for all"
  desc "choose which group of bolts you would like to install"

  def install
    dir_path = [".", "/#{group}"].join
    Find.find(dir_path) do |bolt|
    	if File.file?(bolt) && File.extname(bolt).eql?(".thor")
        thor :install, bolt, :force => true
      end
    end
  end
end
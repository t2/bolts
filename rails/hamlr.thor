require 'find'
require 'rubygems'
begin
  require 'haml'
  require 'haml/exec'
rescue LoadError => e
  dep = e.message[/^no such file to load -- (.*)/, 1]
  puts <<MESSAGE
Required dependency #{dep} not found!
Run "gem install #{dep}" to get it.
MESSAGE
  exit 1
end

class Hamlr < Thor::Group
  include Thor::Actions

  class_option :delete, :default => true, :aliases => "-d", :type => :boolean, :desc => "Delete the original erb files?"
  class_option :html, :default => true, :aliases => "-h", :type => :boolean, :desc => "Convert HTML as well?"

  desc "convert all html/erb views in your project to haml"

  def convert
    branch_project

    exts = [".erb", ".html"]
    exts.delete(".html") unless options[:html]

    Find.find(destination_root) do |f|
      ext = File.extname(f)
      if exts.include? ext
        begin
          haml = Haml::Exec::HTML2Haml.new(["-r", "#{f}", "#{f.gsub(/#{ext}$/, '.haml')}"])
          haml.parse
          remove_file(f) if options[:delete]
        rescue Exception => e
          puts "Oh snap! Error: #{e.message}"
        end
      end
    end
    puts "All files converted. Please confirm changes then merge `hamlr` branch."
  end

private
  def using_git?
    File.directory?('.git')
  end
  
  def branch_project
    if using_git?
      begin
        `git branch -D hamlr` if File.file?("#{destination_root}/.git/refs/heads/hamlr")
        `git checkout -b hamlr`
      rescue Exception => e
        puts "Oh snap! Error: #{e.message}"
        exit 1
      end
    else
      puts "Use git please. I feel bad doing this work without it."
      exit 1
    end
  end
end
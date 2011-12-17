require 'find'
require 'open3'
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

  argument :delete, :default => true, :desc => "Delete the original erb files?"
  desc "convert all html/erb views in your project to haml"

  def convert
    branch_project

    Find.find(destination_root) do |f|
      if File.extname(f).eql?(".erb")
        begin
          haml = Haml::Exec::HTML2Haml.new(["-r", "#{f}", "#{f.gsub(/\.erb$/, '.haml')}"])
          haml.parse
          remove_file(f) if delete
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
        `git checkout master`
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
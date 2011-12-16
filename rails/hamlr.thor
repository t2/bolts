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

class Hamlr < Thor
  include Thor::Actions

  desc "convert", "choose which group of bolts you would like to install"

  def convert
    puts "converting..."
  end
#   desc "hamltime", "convert all html/erb views in your project to haml"
#   method_options :delete => true, :aliases => "-d", :desc => "Delete the original erb file."
#   def hamltime
#     branch_project

#     Find.find(Dir.pwd) do |f|
#       if File.file?(f) && File.extname(f).eql?(".erb")
#         haml = Haml::Exec::HTML2Haml.new(["-r", "#{f}", "#{f.gsub(/\.erb$/, '.haml')}"])
#         haml.parse

#         begin
#           File.delete(f) if options[:delete]
#         rescue Exception => e
#           puts e.message
#         end
#       end
#     end
#     puts "All files converted. Please confirm changes then merge `hamlr` branch."
#   end

# private
#   def project_is_configured_for_git?
#     File.directory? '.git'
#   end
  
#   def branch_project
#     if project_is_configured_for_git?
#       begin
#         # use -d instead of -D so not to remove uncommitted changes
#         `git branch -d hamlr`
#         `git checkout -b hamlr`
#       rescue Exception => e
#         puts "Oh snap! Error: #{e.message}"
#         exit 1
#       end
#     else
#       puts "Use git please. I feel bad doing this work without it."
#       exit 1
#     end
#   end
end
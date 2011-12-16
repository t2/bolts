require 'find'
require 'rubygems'
begin
	require 'haml'
	require 'haml/exec'
rescue LoadError => e
	dep = e.message[/^no such file to load -- (.*)/, 1]
	$stderr.puts <<MESSAGE
Required dependency #{dep} not found!
Run "gem install #{dep}" to get it.
MESSAGE
	exit 1
end

class Hamlr < Thor
	desc "hamltime", "convert all html/erb views in your project to haml"
	method_option :delete => true, :aliases => "-d", :desc => "Delete the original erb file"
	def hamltime
		branch_project

		#
		# traverse project tree and convert erb files to haml.
		# 
		Find.find(File.dirname(__FILE__)) do |f|
			if File.file?(f) && File.extname(f).eql?(".erb")
				haml = Haml::Exec::HTML2Haml.new(["-r", "#{f}", "#{f.gsub(/\.erb$/, '.haml')}"])
				haml.parse
				
				#
				# check if the delete flag was overriden
				#
				delete_file = options[:delete]
				if delete_file
					File.delete(f)
				end
			end
		end
		puts "All files converted. Please confirm changes then merge `hamlr` branch."
	end

	private
		#
		# basic check to see if the project is under git version control
		# 
		def project_is_configured_for_git?
			File.directory? '.git'
		end

		#
		# branch project so that we can undo our changes
		#
		def branch_project
			if project_is_configured_for_git?
				begin
					# use -d instead of -D so not to remove uncommitted changes
					`git branch -d hamlr`
					`git checkout -b hamlr`
				rescue Exception => e
					$stderr.puts "Oh snap! Error: #{e.message}"
					exit 1
				end
			else
				$stderr.puts "Use git please. I feel bad doing this work without it."
				exit 1
			end
		end
end
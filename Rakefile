require 'kitchen'
require 'fileutils'

namespace :test do
  Kitchen::Config.new.instances.each do |instance|
    case instance.name
      when /vagrant/ 
        desc 'Run Test Kitchen in Vagrant'
        task :vagrant do
          Kitchen.logger = Kitchen.default_file_logger
          instance.test(:always)
        end
      when /aws/
        desc 'Run Test Kitchen in AWS'
        task :aws do
          run_shaker = "salt-shaker shake root_formula=ministryofjustice/#{File.basename(Dir.getwd)}"
          puts "Resolving formula dependencies: #{run_shaker}"
          sh run_shaker do |ok, res|
            if !ok
              abort "Failed: (status = #{res.exitstatus})"
            end
          end 
          Kitchen.logger = Kitchen.default_file_logger
          instance.test(:always)
        end
    end
  end
end

task default: ['test:vagrant']

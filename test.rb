# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'
require 'pp'

confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))
homesteadYamlPath = confDir + "/Homestead.yaml"

if File.exist? homesteadYamlPath then
    settings = YAML::load(File.read(homesteadYamlPath))
else
    abort "Homestead settings file not found in #{confDir}"
end

if settings.include? 'sites'
    # pp settings["sites"].flatten

    #look for type=wordpress
    #look for composer
    #look for node
    #look for wpengine-db
    #look for wpengine-sftp
    pp settings["sites"].map()
    # pp set
    # set = settings["sites"]
    # pp set
=begin
    settings["sites"].each do |site|

        config.vm.provision "shell" do |s|
            s.name = "Creating Site: " + site["map"]
            if site.include? 'params'
                params = "("
                site["params"].each do |param|
                    params += " [" + param["key"] + "]=" + param["value"]
                end
                params += " )"
            end
            # s.path = scriptDir + "/serve-#{type}.sh"
            s.path = "./test.sh"
            s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443", site["php"] ||= "7.1", params ||= ""]
        end

        # Configure The Cron Schedule
        if (site.has_key?("schedule"))
            config.vm.provision "shell" do |s|
                s.name = "Creating Schedule"

                if (site["schedule"])
                    s.path = scriptDir + "/cron-schedule.sh"
                    s.args = [site["map"].tr('^A-Za-z0-9', ''), site["to"]]
                else
                    s.inline = "rm -f /etc/cron.d/$1"
                    s.args = [site["map"].tr('^A-Za-z0-9', '')]
                end
            end
        else
            config.vm.provision "shell" do |s|
                s.name = "Checking for old Schedule"
                s.inline = "rm -f /etc/cron.d/$1"
                s.args = [site["map"].tr('^A-Za-z0-9', '')]
            end
        end

    end
=end
end

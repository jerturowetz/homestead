# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'
require 'pp'

confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))
homesteadYamlPath = confDir + "/test.yaml"

if File.exist? homesteadYamlPath then
    importedfile = YAML::load(File.read(homesteadYamlPath))
else
    abort "Homestead settings file not found in #{confDir}"
end

# print importedfile
pp importedfile

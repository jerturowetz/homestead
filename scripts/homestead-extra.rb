class HomesteadExtra
    def HomesteadExtra.run(config,settings)

        scriptDir = File.dirname(__FILE__)

        if settings.include? 'sites'

            allKeys = settings["sites"].reduce({}, :update) # flattens array
            if allKeys.include? 'aws-s3-sync'
                #config.vm.provision "shell" do |s|
                #    s.name = "installing AWS CLI"
                #    s.path = scriptDir + "/install-awscli.sh"
                #end
            end

            if h = settings["sites"].find { |h| h['type'] == 'wordpress' }
                #config.vm.provision "shell" do |s|
                #    s.name = "installing WP CLI"
                #    s.path = scriptDir + "/install-wpcli.sh"
                #end
            end

            settings["sites"].each do |site|

                if site.include? 'run-local-scripts'
                    site["run-local-scripts"].each do |script|

                        if script["path"] && script["command"]
                            config.trigger.before :up do
                                run "bash #{scriptDir}/run-local-script.sh '" + script["path"] + "' '" + script["command"] + "'"
                            end
                        end

                    end
                end

                config.trigger.before :up do
                    run "exit"
                end

            end

        end
    end
end


=begin

// TO DO:
generate wp-config
npm & composer install ?
clone db
clean db
wpengine copy
aws copy
                

if site["type"] == 'wordpress'
    # install wordpress

    s.name = "Installing Wordpress for" + site["map"]

    if site.include? 'params'
        params = "("
        site["params"].each do |param|
            params += " [" + param["key"] + "]=" + param["value"]
        end
        params += " )"
    end

    s.path = scriptDir + "/install-wordpress.sh"

    s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443", site["php"] ||= "7.1", params ||= ""]

end



if (site.has_key?("wpengine-db"))
    p site["wpengine-db"]
    # pass args
end

if (site.has_key?("wpengine-sftp"))
    p site["wpengine-sftp"]
    # pass args
end

if (site.has_key?("aws-uploads"))
    p site["aws-uploads"]
    # export vars & pas args
    # pass args
end



=end
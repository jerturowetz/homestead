class HomesteadExtra
    def HomesteadExtra.run(config,settings)

        scriptDir = File.dirname(__FILE__)

        if settings.include? 'sites'

            allKeys = settings["sites"].reduce({}, :update) # flattens array
            if allKeys.include? 'aws-s3-sync'
                #config.vm.provision "shell" do |s|
                    #s.name = "installing AWS CLI"
                    #s.path = scriptDir + "/install-awscli.sh"
                #end
            end

            if h = settings["sites"].find { |h| h['type'] == 'wordpress' }
                config.vm.provision "shell" do |s|
                    s.name = "installing WP CLI"
                    s.path = scriptDir + "/install-wpcli.sh"
                end
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

                if site["type"] == 'wordpress'

                    siteFolder = site['to']
                    dbName = site['dbname']
                    localURL = site['map']
                    wpFolderName = 'wordpress'

                    config.vm.provision "shell" do |s|
                        s.name = "Installing Wordpress for " + site["map"]                        
                        s.privileged = false
                        s.path = scriptDir + "/install-update-wordpress.sh"
                        s.args = [siteFolder, dbName, localURL, wpFolderName]
                    end

                    config.vm.provision "shell" do |s|
                        s.name = "creating wp db for " + site["map"]                        
                        s.privileged = false
                        s.path = scriptDir + "/install-wordpress-db.sh"
                        s.args = [siteFolder, dbName, localURL, wpFolderName]
                    end

                    if (site.has_key?("wpengine"))
                        config.vm.provision "shell" do |s|

                            localDBName = site["dbname"]
                            WPEngineInstallName = site["wpengine"]["install-name"]
                            remoteDBPass = site["wpengine"]["dbpass"]
                            remoteURL = site["wpengine"]["remote-url"]

                            if ( localDBName && WPEngineInstallName && remoteDBPass )
                                s.name = "Runnin WPEngine db copy for " + site["map"]                        
                                s.privileged = false
                                s.path = scriptDir + "/wpengine-db-copy.sh"
                                s.args = [localDBName, WPEngineInstallName, remoteDBPass, localURL, remoteURL]
                            end

                        end
                    end

                end

            end
        end
    end
end

=begin

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
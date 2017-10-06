class HomesteadExtra
    def HomesteadExtra.run(config,settings)
        
        scriptDir = File.dirname(__FILE__)

        if settings.include? 'sites'

            allKeys = settings["sites"].reduce({}, :update) # flattens array

            if allKeys.include? 'aws-s3-sync'
                config.vm.provision "shell" do |s|
                    s.name = "Install/update AWS CLI"
                    s.path = scriptDir + "/install-awscli.sh"
                end
            end

            if allKeys.include? 'wordpress'
                config.vm.provision "shell" do |s|
                    s.name = "Install/update WP CLI"
                    s.path = scriptDir + "/install-wpcli.sh"
                end
            end

            settings["sites"].each do |site|

                if site.include? 'run-local-script'
                    site["run-local-script"].each do |script|
                        if script["local-path"] && script["command"]
                            config.trigger.before :up do
                                run "bash #{scriptDir}/run-local-script.sh '" + script["local-path"] + "' '" + script["command"] + "'"
                            end
                        end
                    end
                end

                if site.include? 'wordpress'

                    localSiteFolder = site['to']
                    localDBName = site["db"]
                    wpSettings= site["wordpress"]

                    if wpSettings.include? 'install-to-folder'
                        config.vm.provision "shell" do |s|
                            s.name = "Installing Wordpress if necesssary " + site["map"]                        
                            s.privileged = false
                            s.path = scriptDir + "/wordpress-core-download.sh"
                            s.args = [localSiteFolder, localDBName, site['map'], wpSettings["install-to-folder"]]
                        end
                    end

                    if site.include? 'wpengine-copy-db'

                        # there's like 0 cleanup on the url if someone accidentally forgets http:// it'll be an issue during search & replace
                        wpEngineInstallName = site['wpengine-copy-db']['install-name']
                        remoteDBPass = site['wpengine-copy-db']['dbpass']
                        replaceURL = site['wpengine-copy-db']['local-url']
                        withURL = site['wpengine-copy-db']['remote-url']

                        config.vm.provision "shell" do |s|
                            s.name = "Attemtping to copying DB from production install"
                            s.privileged = false
                            s.path = scriptDir + "/wpengine-copy-db.sh"
                            s.args = [localSiteFolder, localDBName, replaceURL, withURL, wpEngineInstallName, remoteDBPass, wpSettings["install-to-folder"]]
                        end

                    else

                        config.vm.provision "shell" do |s|
                            s.name = "Creating clean Wordpress DB " + site["map"]                        
                            s.privileged = false
                            s.path = scriptDir + "/wordpress-db-fresh.sh"
                            s.args = [localSiteFolder, site['map'], wpSettings["install-to-folder"]]
                        end

                    end

                    # This will break if no db - which is (sorta) good as that means neither of the DB actions above fired correctly
                    config.vm.provision "shell" do |s|
                        s.name = "Updating Wordpress core " + site["map"]                        
                        s.privileged = false
                        s.path = scriptDir + "/wordpress-core-update.sh"
                        s.args = [localSiteFolder]
                    end

                    if site.include? 'wpengine-copy-uploads-folder'

                        sftpServer = site['wpengine-copy-uploads-folder']['sftpaddress']
                        sftpUser = site['wpengine-copy-uploads-folder']['sftpuser']
                        sftpPass = site['wpengine-copy-uploads-folder']['sftppass']

                        config.vm.provision "shell" do |s|
                            s.name = "Updating Wordpress core " + site["map"]                        
                            s.privileged = false
                            s.path = scriptDir + "/wpengine-copy-uploads-folder.sh"
                            s.args = [localSiteFolder, sftpServer, sftpUser, sftpPass]
                        end
                    end

                    # aws-s3-copy
                    #user: username
                    #pass: password
                    #uploads-folder: /wp-content/uploads

                    #config.vm.provision "shell" do |s|
                    #    s.name = "Setting file & folder permissions"
                    #    s.path = scriptDir + "/wordpress-set-permissions.sh"
                    #    s.args = [localSiteFolder, wpSettings["install-to-folder"]]
                    #end

                end

            end
        end
    end
end

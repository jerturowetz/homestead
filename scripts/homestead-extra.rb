class HomesteadExtra
    def HomesteadExtra.run(config,settings)
        
        scriptDir = File.dirname(__FILE__)

        if settings.include? 'sites'

            allKeys = settings["sites"].reduce({}, :update) # flattens array

            #if allKeys.include? 'aws-s3-copy'
            #    config.vm.provision "shell" do |s|
            #        s.name = "Install/update AWS CLI"
            #        s.privileged = false
            #        s.path = scriptDir + "/install-awscli.sh"
            #    end
            #end

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
                    localDBName = site['db']
                    localSiteURL = site['map']
                    wpSettings = site['wordpress']

                    if wpSettings.include? 'install-to-folder'
                        config.vm.provision "shell" do |s|
                            s.name = "Downloading wordpress core for " + site["map"]
                            s.privileged = false
                            s.path = scriptDir + "/wordpress-core-download.sh"
                            s.args = [localSiteFolder, localDBName, site['map'], wpSettings["install-to-folder"]]
                        end
                    end

                    wpEngineInstallName = site.has_key?("wpengine-db-copy") ? site['wpengine-db-copy']['install-name'] : nil
                    remoteDBPass = site.has_key?("wpengine-db-copy") ? site['wpengine-db-copy']['dbpass'] : nil

                    config.vm.provision "shell" do |s|
                        s.name = "Installing wordpress database"
                        s.privileged = false
                        s.path = scriptDir + "/wordpress-db-setup.sh"
                        if remoteDBPass && wpEngineInstallName
                            s.args = [localSiteFolder, localDBName, localSiteURL, wpSettings["install-to-folder"], wpEngineInstallName, remoteDBPass]
                        else
                            s.args = [localSiteFolder, localDBName, localSiteURL, wpSettings["install-to-folder"]]
                        end
                    end

                    if site.include? 'db-search-replace'
                        site["db-search-replace"].each do |replacetask|
                            config.vm.provision "shell" do |s|
                                s.name = "Running WP search and replace task"
                                s.privileged = false
                                s.path = scriptDir + "/wordpress-db-search-replace.sh"
                                s.args = [localSiteFolder, replacetask['find'], replacetask['replace-with']]
                            end
                        end
                    end

                    config.vm.provision "shell" do |s|
                        s.name = "Updating Wordpress core " + site["map"]                        
                        s.privileged = false
                        s.path = scriptDir + "/wordpress-core-update.sh"
                        s.args = [localSiteFolder,localSiteURL,wpSettings["install-to-folder"]]
                    end

                    if site.include? 'wpengine-copy-uploads-folder'

                        sftpServer = site['wpengine-copy-uploads-folder']['sftpaddress']
                        sftpUser = site['wpengine-copy-uploads-folder']['sftpuser']
                        sftpPass = site['wpengine-copy-uploads-folder']['sftppass']

                        config.vm.provision "shell" do |s|
                            s.name = "Copying uploads folder from WP-Engine for " + site["map"]                        
                            s.privileged = false
                            s.path = scriptDir + "/wpengine-copy-uploads-folder.sh"
                            s.args = [localSiteFolder, sftpServer, sftpUser, sftpPass]
                        end
                    end

                    #if site.include? 'aws-s3-copy'
                    #    awsID = site['aws-s3-copy']['id']
                    #    awsSecret = site['aws-s3-copy']['secret']
                    #    config.vm.provision "shell" do |s|
                    #        s.name = "Copying down from AWS bucket"
                    #        s.path = scriptDir + "/aws-s3-copy.sh"
                    #        s.args = [localSiteFolder, awsID, awsSecret]
                    #    end
                    #end

                end

            end
        end
    end
end

class HomesteadExtra
    def HomesteadExtra.run(config,settings)
        
        scriptDir = File.dirname(__FILE__)

        if settings.include? 'sites'

            allKeys = settings["sites"].reduce({}, :update)

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

                if site.include? 'wordpress-folder'

                    localSiteFolder = site['to']
                    localDBName = site['db']
                    localSiteURL = site['map']
                    localWordpressFolder = site['wordpress-folder']

                    config.vm.provision "shell" do |s|
                        s.name =  localSiteURL + ": Downloading WP Core if doesnt exist"
                        s.privileged = false
                        s.path = scriptDir + "/wordpress-core-download.sh"
                        s.args = [localSiteFolder, localDBName, localSiteURL, localWordpressFolder]
                    end

                    config.vm.provision "shell" do |s|
                        s.name =  localSiteURL + ": Setting up Wordpress database"
                        s.privileged = false
                        s.path = scriptDir + "/wordpress-db-setup.sh"

                        wpEngineInstallName = site.has_key?("wpengine-db-copy") ? site['wpengine-db-copy']['install-name'] : nil
                        remoteDBPass = site.has_key?("wpengine-db-copy") ? site['wpengine-db-copy']['dbpass'] : nil

                        if remoteDBPass && wpEngineInstallName
                            s.args = [localSiteFolder, localDBName, localSiteURL, localWordpressFolder, wpEngineInstallName, remoteDBPass]
                        else
                            s.args = [localSiteFolder, localDBName, localSiteURL, localWordpressFolder]
                        end
                    end

                    if site.include? 'db-search-replace'
                        site["db-search-replace"].each do |replacetask|
                            config.vm.provision "shell" do |s|
                                s.name = localSiteURL + ": Running search and replace tasks on Wordpress database"
                                s.privileged = false
                                s.path = scriptDir + "/wordpress-db-search-replace.sh"
                                s.args = [localSiteFolder, replacetask['find'], replacetask['replace-with']]
                            end
                        end
                    end

                    config.vm.provision "shell" do |s|
                        s.name = localSiteURL + ": Updating Wordpress core"           
                        s.privileged = false
                        s.path = scriptDir + "/wordpress-core-update.sh"
                        s.args = [localSiteFolder, localSiteURL, localWordpressFolder]
                    end

                    if site.include? 'wpengine-copy-uploads-folder'

                        sftpServer = site['wpengine-copy-uploads-folder']['sftpaddress']
                        sftpUser = site['wpengine-copy-uploads-folder']['sftpuser']
                        sftpPass = site['wpengine-copy-uploads-folder']['sftppass']

                        config.vm.provision "shell" do |s|
                            s.name = localSiteURL + ": Copying uploads folder from WP-Engine"
                            s.privileged = false
                            s.path = scriptDir + "/wpengine-copy-uploads-folder.sh"
                            s.args = [localSiteFolder, sftpServer, sftpUser, sftpPass]
                        end
                    end

                end

            end
        end
    end
end

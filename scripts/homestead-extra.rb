class HomesteadExtra
    def HomesteadExtra.run(config,settings)

        if settings.include? 'sites'
            if h = settings["sites"].find { |h| h['type'] == 'wordpress' }
                p "Has wordpress"
            else
                p "no wordpress"
            end            
        end


        ## to do
        
        ## clone db
        ## clean db
        ## copy uploads
=begin

        if settings.include? 'sites'

            # Flattens the array and checks if a key exists - no use yet
            #allKeys = settings["sites"].reduce({}, :update)
            #if allKeys.include? 'composer'
            #    pp "has composer"
            #end
        
            config.vm.provision "shell" do |s|
                s.name = "testing additions"
                s.inline = "pwd"
                # s.args = [site["map"].tr('^A-Za-z0-9', '')]
            end

        end

        if settings.include? 'sites'
            settings["sites"].each do |site|

                if (site.has_key?("wpengine-db"))
                    # pp "has wpengine-db"
                    pp site["wpengine-db"]
                end

                if (site.has_key?("wpengine-sftp"))
                    pp site["wpengine-sftp"]
                end

                if (site.has_key?("aws-uploads"))
                    pp site["aws-uploads"]
                end

                if site.include? 'composer'
                    pp "has composer"
                end
            
                if site.include? 'node'
                    pp "has node"
                end

            end
        end
=end
    end
end

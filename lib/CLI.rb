class Champion::CLI
    
    def call
        puts "Welcome to LoL Info! Please enter a champion name, or type exit to exit."
        get_champ
    end

    def get_champ
        champ_name = gets.chomp
        if champ_name == "exit"
            goodbye
        else
            scraper = LolWikiScraper.new(champ_name)
            if scraper.valid_champ?
                loaded = Champ.new(scraper.scrape)
                puts "#{loaded.name} - #{loaded.title}, has been loaded."
                inputs(loaded)
            else
                puts "Sorry that was not a valid champ, please enter a valid champ name."
                get_champ
            end
        end

    end

    def goodbye
        puts "Thanks for using LoL Info, see you on the Rift!"
    end

    def inputs(champion)
        input = nil
        until input == "exit" || input == "new"
            puts "What would you like to know about #{champion.name}? For a list of commands, type help, or type exit to exit."
            input = gets.chomp.downcase
            case input
            when "help"
                puts "role, resource, range type, damage type, health, speed, range, passive, q, w, e, r, ult, ultimate"
            when "role"
                puts champion.role
            when "resource"
                puts champion.resource
            when "range type"
                puts champion.range_type
            when "damage type"
                puts champion.damage
            when "health"
                puts champion.health
            when "speed"
                puts champion.movespeed
            when "range"
                puts champion.range
            when "passive"
                puts champion.passive
            when "q"
                puts champion.ability_q
            when "w"
                puts champion.ability_w
            when "e"
                puts champion.ability_e
            when "r" || "ult" || "ultimate"
                puts champion.ability_r
            when "new"
                puts "Which champ would you like to load?"
                get_champ
            when "exit"
                goodbye
            else
                puts "That is not a valid entry, try again or type help for a list of options."
            end
        end
        # if input == "exit"
        #     goodbye
        # # elsif input == "new"
        # #     get_champ
        # end
    end
end
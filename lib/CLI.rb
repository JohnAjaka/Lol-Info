require 'pry'
require_relative './champion'
require_relative './lol_wiki_scraper'


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
            data = LolWikiScraper.new(champ_name)
            loaded = Champ.new(data.scrape)
            puts "#{loaded.name} - #{loaded.title}, has been loaded."
            inputs(loaded)
        end

    end

    def goodbye
        puts "Thanks for using LoL Info, see you on the Rift!"
    end

    def inputs(champion)
        input = nil
        while input != "exit"
            puts "What would you like to know about ahri? #{champion.name}. For a list of commands, type help, or type exit to exit."
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
            end
        end

    end
end
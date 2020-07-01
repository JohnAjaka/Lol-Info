class LolWikiScraper
    attr_accessor :name, :url_name

    def initialize(name)
        @name = name
        normalize
        # binding.pry
    end

    def normalize
        if @name.include?("'")
            split_name = @name.split("'")
            @url_name = split_name.map {|part| part.capitalize}.join("'")
        else 
            split_name = @name.split(" ")
            @url_name = split_name.map {|part| part.capitalize}.join("_")
        end
        @url_name
    end

    def valid_champ?
        url = URI.parse("https://leagueoflegends.fandom.com/wiki/#{@url_name}")
        req = Net::HTTP.new(url.host, url.port)
        req.use_ssl = true
        res = req.request_head(url.path)
        if res.code == "200"
            true
        else 
            false
        end
    end

    def scrape
        attributes = {}
        champ_info = Nokogiri::HTML(open("https://leagueoflegends.fandom.com/wiki/#{@url_name}"))
        champ_data = Nokogiri::HTML(open("https://leagueoflegends.fandom.com/wiki/#{@url_name}/Abilities"))
        attributes[:name] = champ_info.css(".champion-header").css("span")[0].text
        attributes[:title] = champ_info.css(".champion-header").css("span")[1].text
        attributes[:role] = champ_info.css(".champion-header").css("span")[2].text
        attributes[:resource] = champ_info.css(".champion-header").css("span")[3].text.strip
        attributes[:range_type] = champ_info.css(".champion-header").css("span")[4].text
        attributes[:damage] = champ_info.css(".champion-header").css("span")[5].text
        base_health = champ_data.css(".pi-smart-data-value").first.text.strip.split("Health")[1].split("+")[0].to_i
        health_per_lvl = champ_data.css(".pi-smart-data-value")[0].text.strip.split("Health")[1].split("+")[1].to_i
        attributes[:health] = "#{base_health} - #{base_health + health_per_lvl*17}"
        attributes[:movespeed] = champ_data.css(".pi-smart-data-value")[8].text.strip.split("Move. speed")[1]
        attributes[:range] = champ_data.css(".pi-smart-data-value")[9].text.strip.split("Attack range")[1]
        attributes[:passive] = champ_data.css(".skill_header").first.text.strip.split("\n\n\n")[1].delete("\n")
        q_info = champ_data.css(".skill_header")[1].text.strip.split("\n\n\n")[1].split("\n")
        attributes[:ability_q] = q_info[0]
        w_info = champ_data.css(".skill_header")[2].text.strip.split("\n\n\n")[1].split("\n")
        attributes[:ability_w] = w_info[0]
        e_info = champ_data.css(".skill_header")[3].text.strip.split("\n\n\n")[1].split("\n")
        attributes[:ability_e] = e_info[0]
        r_info = champ_data.css(".skill_header")[4].text.strip.split("\n\n\n")[1].split("\n")
        attributes[:ability_r] = r_info[0]
        attributes
        # binding.pry
    end
end

# gives name, title, roles, resource, ranged or melee, damage type - champ_info.css(".champion-header").text 
# gives the attributes split up - champ_info.css(".champion-header").text.split("\n")
# returns the champs name - champ_info.css(".champion-header").css("span")[0].text
# returns title - champ_info.css(".champion-header").css("span")[1].text
# returns role - champ_info.css(".champion-header").css("span")[2].text
# returns resource - champ_info.css(".champion-header").css("span")[3].text
# returns ranged or melee - champ_info.css(".champion-header").css("span")[4].text
# returns damage type - champ_info.css(".champion-header").css("span")[5].text
# returns health and health per level in a array of 2 - health_array = champ_data.css(".pi-smart-data-value").first.text.strip.split("Health")[1].split("+")

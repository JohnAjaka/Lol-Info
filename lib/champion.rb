require 'pry'
require_relative "champion/version"
require_relative './CLI'
require_relative './lol_wiki_scraper'

class Champ
    attr_accessor :name, :title, :role, :resource, :range_type, :damage, :health, :movespeed, :range, :passive, :ability_q, :ability_w, :ability_e, :ability_r
    @@all = []
    def initialize(attributes)
      attributes.each {|key, value| self.send(("#{key}="), value)}
      return self
    end

    def self.all
      @@all
    end
end

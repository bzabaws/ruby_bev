require 'ostruct'

class Game
  class << self

    def play_round
      population = player_population
      printf "PLAY DA ROUND\n-------------\n"
      population.shuffle.each_with_index { |player, i| printf "Round #{i}:\n%s\n\n", spin_for(player, population) };nil
    end

    def player_population
      [ %W[John male], %W[Mary female], %W[Bill male] ].inject([]) { |population, player| population << OpenStruct.new(name: player.shift, gender: player.shift) }
    end

    # INPUT
    # => player: a unique player
    # => population: total set of players in game
    #
    # OUTPUT
    # => string that contains name of the player and the
    # person they got in their spin. Make sure they dont return themselves beverly or you failed >:(
    def spin_for(player, population)
      # new_population = population - [player]
      # temp = new_population.shuffle

      chosen_player = (population - [player]).shuffle.first
      "Player #{player.name} got Player #{chosen_player.name} and it was true love. <3"
    end

  end
end

### Fun with data structures

# global var
MAGIC_NUMBER = 2

# better way than global var
class Constants
  def self.magic_number; 2 end
end

# With OpenStruct
#
# INPUT: set of players
# OUTPUT: the two players that were chosen
class Spin_o
  class << self
    def player_population
      pop = []
      [ %W[John male], %W[Mary female], %W[Bill male] ].each { |p| pop << OpenStruct.new(name: p.shift, gender: p.shift)}
      pop
    end

    def test(func, num)
      (0..num).each { |nfa| p eval("Spin_o."+func).to_a };nil
    end

    def spin_bev_v2
      temp = player_population.shuffle[0..1]
      return temp.first.name, temp.last.name
      # player_population.shuffle[0..1].map(&:name)
    end

    def spin_set_theory
      player_population.sample(Constants.magic_number).map(&:name)
    end
  end
end

# With Arrays
#
# INPUT: set of players
# OUTPUT: the two players that were chosen
class Spin_a
  class << self
    def spin_bev(players)
      return players.shuffle[0,2]
    end

    def spin_set_theory(players)
      p1 = players.sample
      p2 = (players - [p1]).sample
      return p1, p2
    end

    def spin_set_theory_p2(players)
      players.sample(2)
    end
  end
end

class Board

  def initialize(size = 100)
    @colors = ["red", "green", "blue", "purple", "orange"]
    @pink_colors = ["pink candy cane", "pink gumdrop"]
    @size = size
    @shortcuts = []
    build
  end

  def build
    @track = []
    16.times do |i|
      @track += @colors
      @track << @pink_colors[i % 2]
    end
    4.times do |i|
      @track << @colors[i]
    end
    @shortcuts << Random.new.rand(0..(@track.size / 2))
    @shortcuts << Random.new.rand(((@track.size / 2) + 1)..(@track.size - 1))
  end

  def find_position(current_position, card)
    if card.reverse
      move(current_position, card.color, :backward)
    else
      move(current_position, card.color, :forward)
    end
    current_position
  end

  def move(current_position, color, direction)
    while current_position >= start_position && current_position <= final_position
      if @track[current_position] == card.color
         return evaluate_shortcuts(current_position)
      end
      current_position += direction == :forward ? 1 : -1
    end
  end

  def evaluate_shortcuts(position)
    return @track.size - 1 if current_position == @shortcuts.first
    return 0 if current_position == @shortcuts.last
    return current_position
  end

  def finish_position
    @track.size - 1
  end

  def start_position
    0
  end

  def finished?(position)
    position == @track.size - 1
  end

end

class Card

  attr_accessor :color, :reverse

  def initialize(color, reverse = false)
    @color = color
    @reverse = reverse
  end

end

class Deck

  def initialize(size = 64)
    @colors = ["red", "green", "blue", "purple", "orange"]
    @pink_colors = ["pink candy cane", "pink gumdrop"]
    @size = size
    @picked_cards = []
    build
  end

  def build
    @cards = []
    9.times do
      @colors.each { |color| @cards << Card.new(color, false) }
    end
    @cards << Card.new(@colors.first, false)
    @cards << Card.new(@colors[1], false)
    @pink_colors.each do |pink_color|
      @cards << Card.new(pink_color, true)
      @cards << Card.new(pink_color, false)
    end
  end

  def pick
    card = @cards.shift
    @picked_cards << card
    card
  end

  def shuffle
    @cards.shuffle!
  end

  def empty?
    @cards.empty?
  end

  def rebuild
    @cards = @picked_cards.shuffle
    @picked_cards = []
  end

end

class Player

  attr_accessor :number, :position

  def initialize(number, position = 1)
    @number = number
    @position = position
  end

end

class Game

  def initialize(players_size = 1)
    @board = Board.new
    @deck = Deck.new
    @players = []
    players_size.times do |i|
      @players << Player.new(i+1)
    end
  end

  def play
    @deck.shuffle
    steps = 1
    while true
      @players.each do |player|
        if finished?(player)
          if @players.size > 1
            puts "Player #{player.number} won!"
          else
            puts "Finished in #{steps} steps!"
          end
          return
        elsif @deck.empty?
          @deck.rebuild
        end
        turn(player)
        puts "Player #{player.number} is at position #{player.position}."
      end
      steps += 1
    end
  end

  def turn(player)
    card = @deck.pick
    player.position = @board.find_position(player.position, card)
  end

  def finished?(player)
    @board.finished?(player.position)
  end

end

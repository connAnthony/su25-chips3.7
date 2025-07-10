class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def guess(char)
    if char.nil? || char.empty? || !char.match("[A-Za-z]")
      raise ArgumentError, "Enter a single letter"
    end
    char = char.downcase
    if !@guesses.include?(char) && @word.include?(char)
      @guesses += char
    elsif !@word.include?(char) && !@wrong_guesses.include?(char)
      @wrong_guesses += char
    else
      false
    end
  end

  def word_with_guesses
    builder = ""
    @word.each_char do |char|
      if @guesses.include?(char)
        builder += char
      else
        builder += "-"
      end
    end
    builder
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7
        return :lose
    end
    @word.each_char do |char|
      if !(@guesses.include?(char))
        return :play
      end
    end
    :win
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end

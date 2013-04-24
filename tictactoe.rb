class Game

  def new
    start_query
  end

  def initialize
    @board = {
    "1"=>"1","2"=>"2","3"=>"3",
    "4"=>"4","5"=>"5","6"=>"6",
    "7"=>"7","8"=>"8","9"=>"9"
     }
     
    @rules = {
    "1"=>"1","2"=>"2","3"=>"3",
    "4"=>"4","5"=>"5","6"=>"6",
    "7"=>"7","8"=>"8","9"=>"9"
     }
  end
  
  def make_board
    puts " #{@board["1"]} | #{@board["2"]} | #{@board["3"]}"
    puts "------------"
    puts " #{@board["4"]} | #{@board["5"]} | #{@board["6"]}"
    puts "------------"
    puts " #{@board["7"]} | #{@board["8"]} | #{@board["9"]}"
    puts ""
  end
  
  def start_query
    puts "===================================================="
    puts "Welcome to Ruby TicTacToe!"
    puts "Please enter your name and strike return:"
    puts "===================================================="
    user_name = gets.chomp!
    puts "===================================================="
    puts "Hi #{user_name}! Would you like to go first [Y,n] ?"
    puts "===================================================="
    answer_gate(gets.chomp)
  end
  
  def answer_gate(str)
    if str == "Y"
      puts ""
      @answer = str
      square_select_user
    elsif str == "n"
      puts ""
      puts "Thinking........."
      puts ""
      sleep(1)
      @answer = str
      @board["5"] = "O"
      square_select_user
    end 
    while @answer != "Y" || "n"
      try_query
    end
  end

  def matches_number?(str)
    pattern = /^[1-9]$/
    !pattern.match(str).nil?
  end
    
  def is_numeric?(str)
    if matches_number?(str)
      @selected_square_user = str
      make_move_user
    else
      try_query_number
    end      
  end
  
  def choice_limiter(str)
    @selected_array = []
    if !@selected_array.include? str
      @selected_array << str
      return true
    else
      try_query_number
    end
  end
  
  
  def try_query_number
    puts ""
    puts "Try again! Please select a square by typing a number, [1..9] and strike return:"
    is_numeric?(gets.chomp)
  end
  
  def try_query_already_selected
    puts ""
    puts "Try again! That's already been selected"
    make_board
    puts ""
    has_been_selected?(gets.chomp)
  end
   
  def try_query
    puts ""
    puts "Try again! Would you like to go first [Y,n] ?"
    answer_gate(gets.chomp)
  end
    
  def square_select_user
    make_board
    puts ""
    puts "Please select a value 1..9 and strike return:"
    has_been_selected?(gets.chomp)
  end 
  
  def has_been_selected?(input)
    while !matches_number?(input)
      puts "Try again. Please select a value and strike return:"
      has_been_selected?(gets.chomp)
    end
    if @board[input].include?("X")
      try_query_already_selected
    elsif @board[input].include?("O")
      try_query_already_selected
    else
      is_numeric?(input)
    end
  end
  
  def make_move_user
    if choice_limiter(@selected_square_user)==false
       @available_choice = @selected_square_user
       puts "That square has already been selected!"
       puts ""
       puts "Please try again:"
       @selected_square_user = gets.chomp
       @board["#{@available_choice}"]="X"
    else
       @board["#{@selected_square_user}"]="X"
    end
    make_board
    sleep(1)
    win_check
    square_select_cpu
  end
  
  def square_select_cpu
    @next_array = @rules.select do |array|
      array.include? @selected_square_user
    end
    @next_array.flatten
    cpu_move
    sleep(1)
    win_check
    square_select_user
  end
  
  def cpu_move
    @choice = @board.select {|key,value| value !="X" && value != "O" }.keys
    puts @choice.inspect
    if @board["5"] != "X" && @board["5"] != "O"
      @board["5"] = "O"
    else
    win_block || @board["#{@choice.shuffle.pop}"]="O"
    sleep(1)
    end
  end

  def win_block
    potential_moves = @rules.map { |rule| rule.reject {|e| @board[e] == "X" }} 
    winning_moves = potential_moves.select {|x| x.size == 1}.flatten
    puts "#{winning_moves}".inspect
    if winning_moves.any?
      @board[winning_moves.first] = "O"
    else
      return false
    end
  end

  def possible_winning_positions
    [ [1,2,3], [4,5,6], [7,8,9],
      [1,5,9], [3,5,7],
      [1,4,7], [2,5,8], [3,6,9] ]
  end

  def win_check
    [ 'X', 'O' ].each do |player| 
      found_win = possible_winning_positions.find do |position|
        check_win_for_player position, player
      end
      puts "Player #{player} wins!" if found_win
      exit if found_win
    end
  end

  def check_win_for_player(positions,player)
    positions.all? {|position| @board[position.to_s] == player }
  end

  
end

game = Game.new
game.new

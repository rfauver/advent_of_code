data = File.readlines('4.txt', chomp: true)

draws = data.shift.split(',')
data.shift
boards = []
current_board = []
data.each do |line|
  if (line == '')
    boards << current_board
    current_board = []
  else
    current_board << line.split
  end
end

# part 1

winner = nil
last_draw = nil

draws.each do |draw|
  last_draw = draw
  boards.each_with_index do |board, i|
    board.each_with_index do |board_row, y|
      board_row.each_with_index do |val, x|
        boards[i][y][x] = true if val == draw
      end
    end
  end

  boards.each_with_index do |board, i|
    row_match = board.any? { |board_row| board_row.all? { |val| val == true } }
    column_match = 0.upto(4).any? do |y|
      board.map { |board_row| board_row[y] }.all? { |val| val == true }
    end
    diag_down_match = 0.upto(4).all? { |y| board[y][y] == true }
    diag_up_match = 0.upto(4).all? { |y| board[-y - 1][y] == true }
    winner = i if row_match || column_match || diag_down_match || diag_up_match
  end
  break if winner
end

p boards[winner].flatten.filter { |val| val != true }.map(&:to_i).sum * last_draw.to_i


# part 2
data = File.readlines('4.txt', chomp: true)

draws = data.shift.split(',')
data.shift
boards = []
current_board = []
data.each do |line|
  if (line == '')
    boards << current_board
    current_board = []
  else
    current_board << line.split
  end
end

winner = nil
last_draw = nil

draws.each do |draw|
  last_draw = draw
  boards.each_with_index do |board, i|
    next unless board
    board.each_with_index do |board_row, y|
      board_row.each_with_index do |val, x|
        boards[i][y][x] = true if val == draw
      end
    end
  end

  boards.each_with_index do |board, i|
    next unless board
    row_match = board.any? { |board_row| board_row.all? { |val| val == true } }
    column_match = 0.upto(4).any? do |y|
      board.map { |board_row| board_row[y] }.all? { |val| val == true }
    end
    diag_down_match = 0.upto(4).all? { |y| board[y][y] == true }
    diag_up_match = 0.upto(4).all? { |y| board[-y - 1][y] == true }
    if row_match || column_match || diag_down_match || diag_up_match
      if boards.compact.length == 1
        winner = i
      else
        boards[i] = nil
      end
    end
  end
  break if winner
end

p boards[winner].flatten.filter { |val| val != true }.map(&:to_i).sum * last_draw.to_i

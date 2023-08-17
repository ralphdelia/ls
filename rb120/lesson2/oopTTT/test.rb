
def computer_moves
  square = find_best_move(computer.marker) || find_best_move(human.marker) || board.unmarked_keys.sample
  board[square] = computer.marker
end

def find_best_move(marker)
  return board.return_imminent_third_match(marker) if board.winning_move_availbale?(marker)
end

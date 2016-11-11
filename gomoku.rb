# CSCI3180 Principles of Programming Languages
# --- Declaration ---
# I declare that the assignment here submitted is original except for source material explicitly
# acknowledged. I also acknowledge that I am aware of University policy and regulations on
# honesty in academic work, and of the disciplinary guidelines and procedures applicable to
# breaches of such policy and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
# Assignment 2
# Name: CHOW Wai Kwong, Kyle
# Student ID: 1155074568
# Email Addr: 1155074568@link.cuhk.edu.hk

class Gomoku
	@board
	@player1
	@player2
	@turn
	@firstplayer
	@secondplayer
	@input
	@win
	def initialize
		@board = Array.new(15){Array.new(15)}
		for i in 0..14
			for j in 0..14
				@board[i][j] = '.'
			end
		end
		@turn = 'O'
		@win = -1
	end
	def startGame
		# Ask user select type
		print("First player is (1) Computer or (2) Human? ")
		@firstplayer = gets()
		@firstplayer = @firstplayer.to_i
		if(@firstplayer == 2)
			@player1 = Human.new('O')
			puts("Player O is Human")
		else
			@player1 = Computer.new('O')
			puts("Player O is Computer")
		end	
		print("Second player is (1) Computer or (2) Human? ")
		@secondplayer = gets()
		@secondplayer = @secondplayer.to_i
		if(@secondplayer == 2)
			@player2 = Human.new('X')
			puts("Player X is Human")
		else
			@player2 = Computer.new('X')
			puts("Player X is Computer")
		end



		checkcoord = Array.new(2)
		while(@win == -1) #Start for each round, printboard, check victory
			printBoard()
			@player1.algrithom(@board)
			coord = @player1.nextMove()
			while(@board[coord[0]][coord[1]] != '.')
				puts("Invalid input. Try again!")
				coord = @player1.nextMove()
			end
			@board[coord[0]][coord[1]] = 'O'
			puts("Player O places to row #{coord[0]}, col #{coord[1]}")
			checkcoord = @player1.checking(@board,4)
			if(checkcoord[0] != -1 && checkcoord[0] != -1)
				printBoard()
				puts("Player O wins!")
				break
			end
			if(draw() == false)
				puts("Draw!")
				break
			end
			printBoard()
			@player2.algrithom(@board)
			coord = @player2.nextMove()
			while(@board[coord[0]][coord[1]] != '.')
				puts("Invalid input. Try again!")
				coord = @player2.nextMove()
			end
			@board[coord[0]][coord[1]] = 'X'
			puts("Player X places to row #{coord[0]}, col #{coord[1]}")
			checkcoord = @player2.checking(@board,4)
			if(checkcoord[0] != -1 && checkcoord[0] != -1)
				printBoard()
				puts("Player X wins!")
				break
			end
			if(draw() == false)
				puts("Draw!")
				break
			end			
		end
	end
	def printBoard
		puts("                       1 1 1 1 1")
		puts("   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4")
		for i in 0..14
			if(i<10)
				print(" ")
			end
			print(i," ")
			for j in 0..14
				print(@board[i][j]," ")
			end
			puts("")
		end
	end
	def draw
		for i in 0..14
			for j in 0..14
				if(@board[i][j]=='.')
					return true
				end
			end
		end
		return false
	end	
end

class Player
	@symbol
	@coord
	def initialize(input)
		@symbol = input
	end
	def algrithom(board) #Abstract Class for computer use, get the board info for computer AI
	end
	def nextMove
	end
	def checkleft_bottom_to_right_top(board,condition) #check 5 consistent symbol leftbottom -> righttop
		count = 0
		coord = Array.new(3)
		coord[0] = -1
		coord[1] = -1
		found = -1	


		for i in 0..14
			for j in 0..14
				if(i >=4 && j<=10)
					for k in 0..3
						if(board[i-k][j+k] == board[i-k-1][j+k+1] && board[i-k][j+k]!='.')
							count += 1
							#puts "left_bottom_to_right_top: board[#{i-k}][#{j+k}] board[#{i-k-1}][#{j+k+1}] #{count}"
						else
							break
						end
					end
					if(count == condition)
						found = 4
						coord[0] = i
						coord[1] = j
						break
					end
					count = 0
				end
			end
			if(found != -1)
				break
			end
		end
		coord[2] = found
		return coord
	end
	def checkleft_top_to_right_bottom(board,condition)	#check 5 consistent symbol lefttop -> rightbottom
		count = 0
		coord = Array.new(3)
		coord[0] = -1
		coord[1] = -1
		found = -1	
		for i in 0..14
			for j in 0..14
				if(j <= 10 && i<=10)
					for k in 0..3
						if(board[i+k][j+k] == board[i+k+1][j+k+1] && board[i+k][j+k]!='.')
							count += 1
							#puts "left_top_to_right_bottom: board[#{i+k}][#{j+k}] board[#{i+k+1}][#{j+k+1}] #{count}"
						else
							break
						end
					end
					if(count == condition)
						found = 3
						coord[0] = i
						coord[1] = j
						break
					end
					count = 0
				end
			end
			if(found != -1)
				break
			end
		end
		coord[2] = found
		return coord
	end
	def checkvertical(board,condition) #check 5 consistent symbol left -> right
		count = 0
		coord = Array.new(3)
		coord[0] = -1
		coord[1] = -1
		found = -1
		for i in 0..14
			for j in 0..14
				if(j <= 10)
					for k in 0..3
						if(board[j+k][i] == board[j+k+1][i] && board[j][i]!='.')
							count += 1
							#puts "Vertical: board[#{j+k}][#{i}] board[#{j+k+1}][#{i}] #{count}"
						else
							break
						end
					end
					if(count == condition)
						found = 2
						coord[0] = j
						coord[1] = i
						break
					end
					count = 0
				end
			end
			if(found != -1)
				break
			end
		end
		coord[2] = found
		return coord
	end
	def checkhorizon(board,condition) #check 5 consistent symbol top -> down
		count = 0
		coord = Array.new(3)
		coord[0] = -1
		coord[1] = -1
		found = -1
		for i in 0..14
			for j in 0..14
				if(j <= 10)
					for k in 0..3
						if(board[i][j+k] == board[i][j+k+1] && board[i][j]!='.')
							count += 1
							#puts "Honrizontal: board[#{i}][#{j+k}] board[#{i}][#{j+k+1}] #{count}"
						else
							break
						end
					end
					if(count == condition)
						found = 1
						coord[0] = i
						coord[1] = j
						break
					end
					count = 0
				end
			end
			if(found != -1)
				break
			end
		end
		coord[2] = found
		return coord
	end
	def checking(board,condition) #check all combination to win
		coord = Array.new(3)
		coord[0] = -1
		coord[1] = -1

		if(coord[0] == -1 && coord[1] == -1)
			coord = checkhorizon(board,condition)
			#puts "Horizon Coord: #{coord[0]} #{coord[1]}"
		end
		
		if(coord[0] == -1 && coord[1] == -1)
			coord = checkvertical(board,condition)
			#puts "Verical Coord: #{coord[0]} #{coord[1]}"
		end

		if(coord[0] == -1 && coord[1] == -1)
			coord = checkleft_top_to_right_bottom(board,condition)
			#puts "Left_top_to_right_bottom Coord: #{coord[0]} #{coord[1]}"
		end

		if(coord[0] == -1 && coord[1] == -1)
			coord = checkleft_bottom_to_right_top(board,condition)
			#puts "Left_bottom_to_right_top Coord: #{coord[0]} #{coord[1]}"
		end
		# puts "Type: #{coord[2]}, (#{coord[0]},#{coord[1]})"
		return coord
	end
end

class Human < Player
	def nextMove
		coord = Array.new(2)
		problem = true
		while problem
			delimiter = 0
			row = ""
			col = ""
			print("Player #{@symbol}, make a move (row col): ")
			@input = gets()

			#Process input from user, from string to int and check input validity		
			for i in 0..@input.length()
				if(@input[i] == ' ')
					delimiter = i
				end
			end			
			for i in 0..delimiter
				row += @input[i]
			end
			delimiter += 1
			for i in delimiter..@input.length()-1
				col += @input[i]
			end
			row = row.to_i
			col = col.to_i
			if(row > 14 || col > 14 || row < 0)
				problem = true
				puts("Invalid input. Try again!")
			else
				problem = false
			end 
		end

		coord[0] = row
		coord[1] = col
		return coord
	end
end

class Computer < Player
	@board
	def algrithom(board)  #Abstract Class for computer use, get the board info for computer AI
		@board = board
	end
	def readMySymbol(check) #check the position belongs mine or none
		if(check==@symbol)
			return true
		else
			return false
		end
	end
	def pickRandom # Pick a random coordination
		coord = Array.new(3)
		prng = Random.new(Random.new_seed)
		gen_row = prng.rand(0..14)
		prng = Random.new(Random.new_seed)
		gen_col = prng.rand(0..14)		
		coord[0] = gen_row
		coord[1] = gen_col
		return coord
	end
	def nextMove
		coord = Array.new(3)
		coord = pickRandom()
		while(@board[coord[0]][coord[1]] != '.')
			coord = pickRandom()
		end

		for i in 0..14 # Check whether other player near to win in horizontal and give a block coordination
			for j in 0..10
				if(readMySymbol(@board[i][j]) && readMySymbol(@board[i][j+1]) &&
					readMySymbol(@board[i][j+2]) && readMySymbol(@board[i][j+3]) && @board[i][j+4]=='.')
					#puts "(Horizotal E.g O O O O . Found: #{i},#{j})"
					coord[0] = i
					coord[1] = j+4
				elsif(@board[i][j]=='.' && readMySymbol(@board[i][j+1]) && readMySymbol(@board[i][j+2]) &&
					readMySymbol(@board[i][j+3]) && readMySymbol(@board[i][j+4]))
					#puts "(Horizotal E.g . O O O O Found: #{i},#{j})"
					coord[0] = i
					coord[1] = j
				elsif(readMySymbol(@board[i][j]) && readMySymbol(@board[i][j+1]) && @board[i][j+2]=='.' &&
					readMySymbol(@board[i][j+3]) && readMySymbol(@board[i][j+4]))
					#puts "(Horizotal E.g O O . O O Found: #{i},#{j})"
					coord[0] = i
					coord[1] = j+2
				elsif(readMySymbol(@board[i][j]) && readMySymbol(@board[i][j+1]) && readMySymbol(@board[i][j+2]) &&
					@board[i][j+3]=='.' && readMySymbol(@board[i][j+4]))
					#puts "(Horizotal E.g O O O . O Found: #{i},#{j})"
					coord[0] = i
					coord[1] = j+3
				elsif(readMySymbol(@board[i][j]) && @board[i][j+1]=='.' && readMySymbol(@board[i][j+2]) &&
					readMySymbol(@board[i][j+3]) && readMySymbol(@board[i][j+4]))
					#puts "(Horizotal E.g O . O O O Found: #{i},#{j})"
					coord[0] = i
					coord[1] = j+1
				end
			end
		end
		for i in 0..14 # Check whether other player near to win in vertical and give a block coordination
			for j in 0..10
				if(readMySymbol(@board[j][i]) && readMySymbol(@board[j+1][i]) &&
					readMySymbol(@board[j+2][i]) && readMySymbol(@board[j+3][i]) && @board[j+4][i]=='.')
					#puts "(Veritcal E.g O O O O . Found: #{j},#{i})"
					coord[1] = i
					coord[0] = j+4
				elsif(@board[j][i]=='.' && readMySymbol(@board[j+1][i]) && readMySymbol(@board[j+2][i]) &&
					readMySymbol(@board[j+3][i]) && readMySymbol(@board[j+4][i]))
					#puts "(Vertical E.g . O O O O Found: #{i},#{j})"
					coord[1] = i
					coord[0] = j
				elsif(readMySymbol(@board[j][i]) && readMySymbol(@board[j+1][i]) && @board[j+2][i]=='.' &&
					readMySymbol(@board[j+3][i]) && readMySymbol(@board[j+4][i]))
					#puts "(Vertical E.g O O . O O Found: #{i},#{j})"
					coord[1] = i
					coord[0] = j+2
				elsif(readMySymbol(@board[j][i]) && @board[j+1][i]=='.' && readMySymbol(@board[j+2][i]) &&
					readMySymbol(@board[j+3][i]) && readMySymbol(@board[j+4][i]))
					#puts "(Vertical E.g O . O O O Found: #{i},#{j})"
					coord[1] = i
					coord[0] = j+1
				elsif(readMySymbol(@board[j][i]) && readMySymbol(@board[j+1][i]) && readMySymbol(@board[j+2][i]) &&
					@board[j+3][i]=='.' && readMySymbol(@board[j+4][i]))
					#puts "(Vertical E.g O O O . O Found: #{i},#{j})"
					coord[1] = i
					coord[0] = j+3
				end
			end
		end		
		for i in 0..10 # Check whether other player near to win from lefttop -> rightbottom and give a block coordination
			for j in 0..10
				if(readMySymbol(@board[i][j]) && readMySymbol(@board[i+1][j+1]) &&
					readMySymbol(@board[i+2][j+2]) && readMySymbol(@board[i+3][j+3]) && @board[i+4][j+4]=='.')
					#puts "(Left top -> right Bottom E.g O O O O . Found: #{i},#{j})"
					coord[0] = i+4
					coord[1] = j+4
				elsif(@board[i][j]=='.' && readMySymbol(@board[i+1][j+1]) && readMySymbol(@board[i+2][j+2]) &&
					readMySymbol(@board[i+3][j+3]) && readMySymbol(@board[i+4][j+4]))
					#puts "(Left top -> right Bottom E.g . O O O O Found: #{i},#{j})"
					coord[0] = i
					coord[1] = j
				elsif(readMySymbol(@board[i][j]) && readMySymbol(@board[i+1][j+1]) && @board[i+2][j+2]=='.' &&
					readMySymbol(@board[i+3][j+3]) && readMySymbol(@board[i+4][j+4]))
					#puts "(Left top -> right Bottom E.g O O . O O Found: #{i},#{j})"
					coord[0] = i+2
					coord[1] = j+2
				elsif(readMySymbol(@board[i][j]) && readMySymbol(@board[i+1][j+1]) && readMySymbol(@board[i+2][j+2]) &&
					@board[i+3][j+3]=='.' && readMySymbol(@board[i+4][j+4]))
					#puts "(Left top -> right Bottom E.g O O O . O Found: #{i},#{j})"
					coord[0] = i+3
					coord[1] = j+3
				elsif(readMySymbol(@board[i][j]) && @board[i+1][j+1]=='.' && readMySymbol(@board[i+2][j+2]) &&
					readMySymbol(@board[i+3][j+3]) && readMySymbol(@board[i+4][j+4]))
					#puts "(Left top -> right Bottom E.g O O O . O Found: #{i},#{j})"
					coord[0] = i+1
					coord[1] = j+1
				end
			end
		end
		for i in 0..10 # Check whether other player near to win from leftbottom -> righttop and give a block coordination
			for j in 0..10
				if(readMySymbol(@board[i][j]) && readMySymbol(@board[i-1][j+1]) &&
					readMySymbol(@board[i-2][j+2]) && readMySymbol(@board[i-3][j+3]) && @board[i-4][j+4]=='.')
					#puts "(Left Bottom -> right top E.g O O O O . Found: #{i},#{j})"
					coord[0] = i-4
					coord[1] = j+4
				elsif(@board[i][j]=='.' && readMySymbol(@board[i-1][j+1]) && readMySymbol(@board[i-2][j+2]) &&
					readMySymbol(@board[i-3][j+3]) && readMySymbol(@board[i-4][j+4]))
					#puts "(Left Bottom -> right top E.g . O O O O Found: #{i},#{j})"
					coord[0] = i
					coord[1] = j
				elsif(readMySymbol(@board[i][j]) && readMySymbol(@board[i-1][j+1]) && @board[i-2][j+2]=='.' &&
					readMySymbol(@board[i-3][j+3]) && readMySymbol(@board[i-4][j+4]))
					#puts "(Left Bottom -> right top E.g O O . O O Found: #{i},#{j})"
					coord[0] = i-2
					coord[1] = j+2
				elsif(readMySymbol(@board[i][j]) && readMySymbol(@board[i-1][j+1]) && readMySymbol(@board[i-2][j+2]) &&
					@board[i-3][j+3]=='.' && readMySymbol(@board[i-4][j+4]))
					#puts "(Left Bottom -> right top E.g O O O . O Found: #{i},#{j})"
					coord[0] = i-3
					coord[1] = j+3
				elsif(readMySymbol(@board[i][j]) && @board[i-1][j+1]=='.' && readMySymbol(@board[i-2][j+2]) &&
					readMySymbol(@board[i-3][j+3]) && readMySymbol(@board[i-4][j+4]))
					#puts "(Left Bottom -> right top E.g O . O O O Found: #{i},#{j})"
					coord[0] = i-1
					coord[1] = j+1
				end
			end
		end		
		# puts "Computer: Will pick (#{coord[0]},#{coord[1]})"
		return coord
	end
end


Gomoku.new.startGame()



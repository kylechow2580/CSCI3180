# CSCI3180 Principles of Programming Languages

# --- Declaration ---

# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/

# Assignment 3
# Name: Chow Wai Kwong,Kyle
# Student ID: 1155074568 
# Email Addr: s1155074568@link.cuhk.edu.hk

use feature ':5.10';

package Reversi;
sub new
{
    my $class = shift;
    my $self = {};
    $board[7][7]='.';
    my $turn = 'X';
    for($i=0;$i<8;$i++) # initialization of board
    {
    	for($j=0;$j<8;$j++)
    	{
    		$board[$i][$j] = '.';
    	}
    }
	$board[3][4] = 'X';    # Set the specific token
	$board[3][3] = 'O';
    $board[4][4] = 'O'; 
    $board[4][3] = 'X';

  
    bless $self, $class;
    return $self;
}
sub startgame
{
    # Ask for user input and declare the type of user
    print "First player is (1) Computer or (2) Human? ";
    my $player1input = <>;
    print "Player X is ";
    if($player1input==1)
    {
    	print "Computer\n";
        $black = Computer->new('X');
    }
    else
    {
    	print "Human\n";
        $black = Human->new('X');
    }
    print "Second player is (1) Computer or (2) Human? ";
    my $player2input = <>;
    print "Player O is ";
    if($player2input==1)
    {
    	print "Computer\n";
        $white = Computer->new('X');
    }
    else
    {
    	print "Human\n";
        $white = Human->new('O');
    }


    while(1) 
    {
        $row = 0;
        $col = 0;

        # Player1 situation checking
        $turn = 'X';
        ($possible,@possiblearr) = $black->checkavailable($turn,@board);
        Reversi->printBoard();
        if(($pass1 == 1 && $pass2 == 1 || $whitecount==0 || $whitecount+$blackcount == 64) && $blackcount == $white)
        {
            print "Draw game!\n";
            last;
        }
        elsif(($pass1 == 1 && $pass2 == 1 || $whitecount==0 || $whitecount+$blackcount == 64) && $blackcount > $white)
        {
            print "Player X win!\n";
            last;
        }
        elsif(($pass1 == 1 && $pass2 == 1 || $whitecount==0 || $whitecount+$blackcount == 64) && $blackcount < $white)
        {
            print "Player O win!\n";
            last;
        }


        # Start to put player1 token
        @arr = $black->nextMove($turn,@board);
        $row = $arr[0];
        $col = $arr[1];
        if($row == -1 && $col == -1)
        {
            print "Row -1, col -1 is invalid! Player $turn passed!\n";
            $pass1 = 1;
        }
        else
        {
            if($black->movefunction($turn,$row,$col,@board) == 1)
            {
                print "Player $turn places to row $row, col $col\n";
                $pass1 = 0;
            }
            else
            {
                print "Row $row, col $col is invalid! Player $turn passed!\n";
                $pass1 = 1;
            }
        }
        

        # Player2 situation checking
        $turn = 'O';
        ($possible,@possiblearr) = $white->checkavailable($turn,@board);
        Reversi->printBoard();
        if(($pass1 == 1 && $pass2 == 1 || $blackcount==0 || $whitecount+$blackcount == 64) && $blackcount == $white)
        {
            print "Draw game!\n";
            last;
        }
        elsif(($pass1 == 1 && $pass2 == 1 || $blackcount==0 || $whitecount+$blackcount == 64) && $blackcount > $white)
        {
            print "Player X win!\n";
            last;
        }
        elsif(($pass1 == 1 && $pass2 == 1 || $blackcount==0 || $whitecount+$blackcount == 64) && $blackcount < $white)
        {
            print "Player O win!\n";
            last;
        }


        # Start to put player2 token
        @arr = $white->nextMove($turn,@board);
        $row = $arr[0];
        $col = $arr[1];
        if($row == -1 && $col == -1)
        {
            print "Row -1, col -1 is invalid! Player $turn passed!\n";
            $pass2 = 1;
        }
        else
        {
            if($white->movefunction($turn,$row,$col,@board) == 1)
            {
                print "Player $turn places to row $row, col $col\n";
                $pass2 = 0;
            }
            else
            {
                print "Row $row, col $col is invalid! Player $turn passed!\n";
                $pass2 = 1;
            } 
        }  
    }
}
sub printBoard
{
	$blackcount = 0;
    $whitecount = 0;
	print "  0 1 2 3 4 5 6 7\n";
	for($i=0;$i<8;$i++)
    {
    	print "$i ";
    	for($j=0;$j<8;$j++)
    	{
    		print "$board[$i][$j] ";
    		if($board[$i][$j]eq'X')
    		{
    			$blackcount++;
    		}
    		elsif($board[$i][$j]eq'O')
    		{
    			$whitecount++;
    		}
    	}
    	print "\n";
    }
    print "Player X: $blackcount\nPlayer O: $whitecount\n"
}






package Player;
sub new 
{
    my $class = shift;
    my $self = { 
        symbol => shift
    };
    bless $self, $class;
    return $self;
}
sub getSymbol
{
    my $self = shift;
    return $self->{"symbol"};
}

sub movefunction
{
    my $self = shift;
    ($turn,$row,$col,@board) = @_;

    # Checking 8 direction can reverse the token or not
    # if at least on direction can reverse
    # return 1 for telling that there are possible step
    # allow player put the token
    $success1 = Player->reversehorizon($turn,0);
    $success2 = Player->reversevertical($turn,0);
    $success3 = Player->reversediagonal1($turn,0);
    $success4 = Player->reversediagonal2($turn,0);
    if(($success1 || $success2 || $success3 || $success4) && $board[$row][$col] eq '.')
    {
        
        $board[$row][$col] = $turn;
        $success1 = Player->reversehorizon($turn,1);
        $success2 = Player->reversevertical($turn,1);
        $success3 = Player->reversediagonal1($turn,1);
        $success4 = Player->reversediagonal2($turn,1);
        return 1;
    }
    else
    {
         return 0;
    }   
}

sub checkavailable
{
    my $self = shift;
    ($turn,@board) = @_;
    $possible = 0;
    # print "=======Available:=====\n";
    # print "Player $turn: \n";

    #check the whole board which place that player can put the token
    for($x=0;$x<8;$x++)
    {
        for($y=0;$y<8;$y++)
        {
            $row = $x;
            $col = $y;
            if($board[$row][$col] eq '.')
            {
                $success1 = Player->reversehorizon($turn,0);    
                $success2 = Player->reversevertical($turn,0);
                $success3 = Player->reversediagonal1($turn,0);
                $success4 = Player->reversediagonal2($turn,0);
                if($success1 || $success2 || $success3 || $success4)
                {
                    $possiblearr[$possible][0] = $row;
                    $possiblearr[$possible][1] = $col;
                    $possible = $possible + 1;
                }
            }
        }
    }
    # print "Num of possible: $possible\n";
    # for($x=0;$x<$possible;$x++)
    # {
    #     print "($possiblearr[$x][0],$possiblearr[$x][1])\n"
    # }
    # print "=======Available:=====\n\n";
    return ($possible,@possiblearr);
}

sub reversehorizon
{
    my $self = shift;
    $result = 0;
    ($sym,$reverse) = @_;

    #using for loop to reverse the sutable horizontol rol.
    for($i=$col+1;$i<8;$i++)    # . O O X
    {      
        if($board[$row][$i] eq '.')
        {
            last;
        }
        elsif($board[$row][$i] eq $sym)
        {
            if($reverse == 1)
            {
                for($j=$col;$j<$i;$j++)
                {
                    $board[$row][$j] = $sym;
                }
            }
            #print "horizon destination: board[$row][$i]\n";
            if($i != $col+1)
            {
                $result = 1;
            }
            last;      
        }
    }
    for($i=$col-1;$i>=0;$i--)
    {
        if($board[$row][$i] eq '.')
        {
            last;
        }
        elsif($board[$row][$i] eq $sym)
        {
            if($reverse == 1)
            {
                for($j=$col;$j>=$i;$j--)
                {
                    $board[$row][$j] = $sym;
                }  
            }
            #print "horizontal destination: board[$row][$i]\n";
            if($i != $col-1)
            {
                $result = 1;
            }
            last;
        }
    }
    return $result;
}

sub reversevertical
{
    my $self = shift;
    ($sym,$reverse) = @_;
    $result = 0;
    #using for loop to reverse the sutable horizontol col.
    for($i=$row+1;$i<8;$i++)
    {
        if($board[$i][$col] eq '.')
        {
            last;
        }
        elsif($board[$i][$col] eq $sym)
        {
            if($reverse == 1)
            {
                for($j=$row;$j<$i;$j++)
                {
                    $board[$j][$col] = $sym;
                }
            }
            # print "vertical destination: board[$i][$col]\n";
            if($i != $row+1)
            {
                $result = 1;
            }
            last;
        }
    }
    for($i=$row-1;$i>=0;$i--)
    {
        if($board[$i][$col] eq '.')
        {
            last;
        }
        elsif($board[$i][$col] eq $sym)
        {
            if($reverse == 1)
            {
                for($j=$row;$j>=$i;$j--)
                {
                    $board[$j][$col] = $sym;
                }
            }
            # print "Vertical destination: board[$i][$col]\n";
            if($i != $row-1)
            {
                $result = 1;
            }
            last;
        }
    }
    return $result;
}

sub reversediagonal1 #/
{
    my $self = shift;
    ($sym,$reverse) = @_;
    $result = 0;
    $nextrow = $row - 1;
    $nextcol = $col + 1;

    #using for loop to reverse the sutable diagonal col, from left-down to top-right.
    while($nextrow>=0 && $nextrow<8 && $nextcol>=0 && $nextrow<8)
    {
        if($board[$nextrow][$nextcol] eq '.')
        {
            last;
        }
        elsif($board[$nextrow][$nextcol] eq $sym)
        {
            if($reverse == 1)
            {
                $copyrow = $row;
                $copycol = $col;
                while($copyrow != $nextrow && $copycol != $nextcol)
                {
                    $board[$copyrow][$copycol] = $sym;
                    $copyrow = $copyrow - 1;
                    $copycol = $copycol + 1;
                }
            }
            #print "diagonal 1 destination: board[$nextrow][$nextcol]\n";
            if($nextrow != $row-1 && $nextcol != $col+1)
            {
                $result = 1;
            }
            last;
        }
        $nextrow = $nextrow - 1;
        $nextcol = $nextcol + 1;
    }


    $nextrow = $row + 1;
    $nextcol = $col - 1;
    while($nextrow>=0 && $nextrow<8 && $nextcol>=0 && $nextrow<8)
    {
        if($board[$nextrow][$nextcol] eq '.')
        {
            last;
        }
        elsif($board[$nextrow][$nextcol] eq $sym)
        {
            if($reverse == 1)
            {
                $copyrow = $row;
                $copycol = $col;
                while($copyrow != $nextrow && $copycol != $nextcol)
                {
                    $board[$copyrow][$copycol] = $sym;
                    $copyrow = $copyrow + 1;
                    $copycol = $copycol - 1;
                }
            }
            #print "d1 destination: board[$nextrow][$nextcol]\n";
            if($nextrow != $row+1 && $nextcol != $col-1)
            {
                $result = 1;
            }
            last;
        }
        $nextrow = $nextrow + 1;
        $nextcol = $nextcol - 1;
    }

    return $result;
}

sub reversediagonal2 #/
{
    my $self = shift;
    ($sym,$reverse) = @_;
    $result = 0;
    $nextrow = $row - 1;
    $nextcol = $col - 1;

    #using for loop to reverse the sutable diagonal col, from right-down to top-left.
    while($nextrow>=0 && $nextrow<8 && $nextcol>=0 && $nextrow<8)
    {
        if($board[$nextrow][$nextcol] eq '.')
        {
            last;
        }
        elsif($board[$nextrow][$nextcol] eq $sym)
        {
            if($reverse == 1)
            {
                $copyrow = $row;
                $copycol = $col;
                while($copyrow != $nextrow && $copycol != $nextcol)
                {
                    $board[$copyrow][$copycol] = $sym;
                    $copyrow = $copyrow - 1;
                    $copycol = $copycol - 1;
                }
            }
            #print "digagonal 2 destination:  board[$nextrow][$nextcol]\n";
            if($nextrow != $row-1 && $nextcol != $col-1)
            {
                $result = 1;
            }
            last;
            
        }
        $nextrow = $nextrow - 1;
        $nextcol = $nextcol - 1;
    }


    $nextrow = $row + 1;
    $nextcol = $col + 1;
    while($nextrow>=0 && $nextrow<8 && $nextcol>=0 && $nextrow<8)
    {
        if($board[$nextrow][$nextcol] eq '.')
        {
            last;
        }
        elsif($board[$nextrow][$nextcol] eq $sym)
        {
            if($reverse == 1)
            {
                $copyrow = $row;
                $copycol = $col;
                while($copyrow != $nextrow && $copycol != $nextcol)
                {
                    $board[$copyrow][$copycol] = $sym;
                    $copyrow = $copyrow + 1;
                    $copycol = $copycol + 1;
                }
            }
            #print "d2 destination: board[$nextrow][$nextcol]\n";
            if($nextrow != $row+1 && $nextcol != $col+1)
            {
                $result = 1;
            }
            last;
        }
        $nextrow = $nextrow + 1;
        $nextcol = $nextcol + 1;
    }
    return $result;
}

sub nextMove
{
}



package Computer;
@ISA = qw(Player);
sub new
{
    my $class = shift;
    my ($symbol) = @_;
    my $self = Player->new($symbol);
    bless $self, $class;
}
sub nextMove
{
    my $self = shift;
    ($turn,@board) = @_;
    @arr = {-1,-1};
    $arr[0] = -1;
    $arr[1] = -1;

    # checking which can place user can add
    # print "\n\n=====Start AI======\n";
    ($value,@answer) = Computer->checkavailable($turn,@board);
    for($z=0;$z<$value;$z++)
    {
        $storagearr[$z][0] = $answer[$z][0];
        $storagearr[$z][1] = $answer[$z][1];
    }

    $min = 64;
    $virtual[7][7] = '.';

    # checking every step user put, the possible step of opposite player.     
    for($z=0;$z<$value;$z++)
    {
        for($x=0;$x<8;$x++)
        {
            for($y=0;$y<8;$y++)
            {
                $virtual[$x][$y] = $board[$x][$y];
            }
        }
        # print "Testing: ($storagearr[$z][0],$storagearr[$z][1])\n";
        Computer->movefunction($turn,$storagearr[$z][0],$storagearr[$z][1],@virtual);
        if($turn eq 'X')
        {
            $temp = 'O';
        }
        else
        {
            $temp = 'X';
        }
        ($found) = Computer->checkavailable($temp,@virtual);
        # print "found Available step: $found\n\n\n\n\n";
        if($found < $min)
        {
            $min = $found;
            $arr[0] = $storagearr[$z][0];
            $arr[1] = $storagearr[$z][1];
        }
    }
    # print "=====End AI======\n\n";
    return @arr;

}



package Human;
@ISA = qw(Player);
sub new
{
    my $class = shift;
    my ($symbol) = @_;
    my $self = Player->new($symbol);
    bless $self, $class;
}
sub nextMove
{
    my $self = shift;
    ($turn) = @_;
    print "Player $turn, make a move (row col): ";
    $input = <>;
    @arr = split(' ',$input);
    return @arr;
}



package main;
$game = Reversi->new();
$game->startgame;
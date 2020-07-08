require './lib/game'
require './lib/chess_methods'
Dir["./lib/pieces/*"].each {|file| require file }

describe Chess_methods do

  describe "#alpha_add" do

    it "increments a chess position (arg1) with the values in arg 2" do
      test = Board.new
      expect(test.alpha_add(['a', 3], [2, 1])).to eql(['c', 4])
    end
  end

  describe "#in_board" do
    let(:test) { Cell.new('W') }
    
    it "returns true if a pos would be on a chess board" do
      expect(test.in_board(['a', 8])).to be_truthy
    end

    it "returns false if a pos would not be on a chess board" do
      expect(test.in_board(['g', 12])).to be_falsey
    end

  end
  
end

describe Game do
  subject { Game }

  describe "#initialize" do

    it "creates a game obj" do
      expect(subject.new).to be_kind_of(Game)
    end

    it "has instance variable for a board obj" do
      test = subject.new.board
      expect(test).not_to be_nil
      expect(test).to be_kind_of(Board)
    end

    it "has an instance variable for player" do
      test = subject.new.player
      expect(test).not_to be_nil
      expect(test).to include('W')
      expect(test).to include('B')
    end

    it "has an instance variable for turn" do
      expect(subject.new.turn).not_to be_nil
    end
  end

end

describe Board do
  subject(:board) { Board.new }

  describe "#initialize" do

    it "creates a board obj" do
      expect(subject).to be_kind_of(Board)
    end

    it "assigns a value to cells" do
      expect(subject.cells).not_to be_nil
    end

  end

  describe "[]" do

    it "returns position values from the @tiles hash" do
      expect(subject['a', 2]).to be_kind_of(Cell)
    end

    it "returns nil if a position does not exist" do
      expect(subject['z', 3]).to be_nil
    end
  end

  describe "[]=" do

    it "sets a value at a position" do
      subject['a', 1] = 'greg'
      expect(subject['a', 1]).to eql('greg')
    end

    it "returns nil if position does not exist" do
      subject['z', 99] = 'greg'
      expect(subject['z', 99]).to be_nil
    end

  end

  describe "#build_board" do
    let(:test_board) { subject.build_board }

    it "returns a hash" do
      expect(test_board).to be_kind_of(Hash)
    end

    it "has 64 key/val pairs" do
      expect(test_board.length).to eql(64)
    end

    it "all values are Cell objects" do
      expect(test_board.values).to all(be_kind_of(Cell))
    end

    it "has keys named according to algebraic chess notation" do
      expect(test_board.has_key?(['a', 5])).to be_truthy
      expect(test_board.has_key?(['g', 8])).to be_truthy
      expect(test_board.has_key?(['h', 1])).to be_truthy
    end
  end

  describe "setup_board" do
    let(:test_board) { subject.setup_board }

    it "adds white pawns" do
      test = test_board[['a', 2]].piece
      expect(test).to be_kind_of(Pawn)
      expect(test.color).to eql('W')
    end

    it "adds black pawns" do
      test = test_board[['a', 7]].piece
      expect(test).to be_kind_of(Pawn)
      expect(test.color).to eql('B')
    end

    it "adds white backline" do
      test1 = test_board[['a', 1]].piece
      expect(test1).to be_kind_of(Rook)
      expect(test1.color).to eql('W')
      
      test2 = test_board[['b', 1]].piece
      expect(test2).to be_kind_of(Knight)
      expect(test2.color).to eql('W')
    end

    it "adds black backline" do
      test1 = test_board[['a', 8]].piece
      expect(test1).to be_kind_of(Rook)
      expect(test1.color).to eql('B')
      
      test2 = test_board[['b', 8]].piece
      expect(test2).to be_kind_of(Knight)
      expect(test2.color).to eql('B')
    end

    it "leaves ranks 3..6 empty" do
      expect(test_board[['a', 3]].piece).to be_nil
      expect(test_board[['b', 4]].piece).to be_nil
      expect(test_board[['c', 5]].piece).to be_nil
      expect(test_board[['d', 6]].piece).to be_nil
    end

  end

  describe "#assign_adjacents" do
    let(:cells) { subject.cells }

    it "adds references to adjacent Cell positions" do
      test = cells[['b', 1]].adjacent
      expect(test).to include(['a', 1])
      expect(test).to include(['a', 2])
      expect(test).to include(['b', 2])
      expect(test).to include(['c', 2])
      expect(test).to include(['c', 1])
    end 

  end

  describe "#check_pos" do

    it "returns true if a position exists on the board" do
      expect(subject.check_pos(['e', 8])).to be_truthy
      expect(subject.check_pos(['c', 2])).to be_truthy
      expect(subject.check_pos(['g', 4])).to be_truthy
    end

    it "returns false if a position does not exist on the board" do
      expect(subject.check_pos(['a', 0])).to be_falsey
      expect(subject.check_pos(['q', 10])).to be_falsey
      expect(subject.check_pos(['m', 2])).to be_falsey
    end

  end


  describe "#txt" do

    it "returns a string" do
      expect(subject.txt).to be_kind_of(String)
    end

    it "represents positions with a '[ ]'" do
      expect(subject.txt).to include("[ ]")
    end

    it "has rank and file guides along x/y axis" do
      expect(subject.txt).to include("1")
      expect(subject.txt).to include("2")
      expect(subject.txt).to include("8")
      expect(subject.txt).to include("7")
      expect(subject.txt).to include("a")
      expect(subject.txt).to include("b")
      expect(subject.txt).to include("g")
      expect(subject.txt).to include("f")
    end
  end

end

describe Cell do

  describe "#initialize" do
    subject(:cell) { Cell.new(['a', 2]) }

    it "creates a cell obj" do
      expect(subject).to be_kind_of(Cell)
    end

    it "has instance variable for position (no default!)" do
      expect(subject.pos).to eql(['a', 2])
    end

    it "has instance variable for piece (default = nil)" do
      expect(subject.piece).to be_nil
    end

    it "has instance variable for adjacent (default = [])" do
      expect(subject.adjacent).to be_kind_of(Array)
    end

  end

  describe "#add_adjacents" do
    let(:cell) { Cell.new(['a', 2]) }

    it "adds references to other Cell positions into the adjacent array" do
      test_cell = Cell.new(['b', 2])
      cell.add_adjacents(test_cell)
      expect(cell.adjacent).to include(test_cell.pos)
    end
  end

  describe "#piece=" do
    
    it "changes the @piece value" do
      test = Cell.new(['a', 7])
      test.piece=(Pawn.new)
      expect(test.piece).to be_kind_of(Pawn)
    end
  end

end

describe Rook do
  subject(:rook) { Rook.new }
  let(:board) { Board.new }

  describe "#initialize" do

    it "creates a rook obj" do
      expect(subject).to be_kind_of(Rook)
    end

    it "can be assgined a color" do
      white = Rook.new('W')
      black = Rook.new('B')
      expect(white.color).to eql("W")
      expect(black.color).to eql("B")
    end

    it "has an instance varable for text representation" do
      white = Rook.new('W')
      black = Rook.new('B')
      expect(white.txt).to eql("\u2656")
      expect(black.txt).to eql("\u265C")
    end

    it "has an instance variable for position (default is nil)" do
      expect(subject.pos).to be_nil
    end

    it "has an instance variable for movement increments (array length > 0)" do
      expect(subject.increments).to be_kind_of(Array)
      expect(subject.increments.length).to eql(28)
    end

  end
end

describe Bishop do
  subject(:bishop) { Bishop.new }
  let(:board) { Board.new }
  
  describe "#initialize" do
  
    it "creates a bishop obj" do
      expect(subject).to be_kind_of(Bishop)
    end
  
    it "can be assgined a color" do
      white = Bishop.new('W')
      black = Bishop.new('B')
      expect(white.color).to eql("W")
      expect(black.color).to eql("B")
    end
  
    it "has an instance varable for text representation" do
      white = Bishop.new('W')
      black = Bishop.new('B')
      expect(white.txt).to eql("\u2657")
      expect(black.txt).to eql("\u265D")
    end
  
    it "has an instance variable for position (default is nil)" do
      expect(subject.pos).to be_nil
    end
  
    it "has an instance variable for movement increments (array length > 0)" do
      expect(subject.increments).to be_kind_of(Array)
      expect(subject.increments.length).to eql(28)
    end
  
  end
end

describe King do
  subject(:king) { King.new }
  let(:board) { Board.new }
    
  describe "#initialize" do
    
    it "creates a king obj" do
      expect(subject).to be_kind_of(King)
    end
    
    it "can be assgined a color" do
      white = King.new('W')
      black = King.new('B')
      expect(white.color).to eql("W")
      expect(black.color).to eql("B")
    end
    
    it "has an instance varable for text representation" do
      white = King.new('W')
      black = King.new('B')
      expect(white.txt).to eql("\u2654")
      expect(black.txt).to eql("\u265A")
    end
    
    it "has an instance variable for position (default is nil)" do
      expect(subject.pos).to be_nil
    end
    
    it "has an instance variable for movement increments (array length > 0)" do
      expect(subject.increments).to be_kind_of(Array)
      expect(subject.increments.length).to eql(8)
    end
    
  end
end

describe Knight do
  subject(:knight) { Knight.new }
  let(:board) { Board.new }
    
  describe "#initialize" do
    
    it "creates a knight obj" do
      expect(subject).to be_kind_of(Knight)
    end
    
    it "can be assgined a color" do
      white = Knight.new('W')
      black = Knight.new('B')
      expect(white.color).to eql("W")
      expect(black.color).to eql("B")
    end
    
    it "has an instance varable for text representation" do
      white = Knight.new('W')
      black = Knight.new('B')
      expect(white.txt).to eql("\u2658")
      expect(black.txt).to eql("\u265E")
    end
    
    it "has an instance variable for position (default is nil)" do
      expect(subject.pos).to be_nil
    end
    
    it "has an instance variable for movement increments (array length > 0)" do
      expect(subject.increments).to be_kind_of(Array)
      expect(subject.increments.length).to eql(8)
    end
    
  end
end

describe Queen do
  subject(:queen) { Queen.new }
  let(:board) { Board.new }
    
  describe "#initialize" do
    
    it "creates a queen obj" do
      expect(subject).to be_kind_of(Queen)
    end
    
    it "can be assgined a color" do
      white = Queen.new('W')
      black = Queen.new('B')
      expect(white.color).to eql("W")
      expect(black.color).to eql("B")
    end
    
    it "has an instance varable for text representation" do
      white = Queen.new('W')
      black = Queen.new('B')
      expect(white.txt).to eql("\u2655")
      expect(black.txt).to eql("\u265B")
    end
    
    it "has an instance variable for position (default is nil)" do
      expect(subject.pos).to be_nil
    end
    
    it "has an instance variable for movement increments (array length > 0)" do
      expect(subject.increments).to be_kind_of(Array)
      expect(subject.increments.length).to eql(56)
    end
    
  end
end

describe Pawn do
  subject(:pawn) { Pawn.new }
  let(:board) { Board.new }
    
  describe "#initialize" do
    
    it "creates a pawn obj" do
      expect(subject).to be_kind_of(Pawn)
    end
    
    it "can be assgined a color" do
      white = Pawn.new('W')
      black = Pawn.new('B')
      expect(white.color).to eql("W")
      expect(black.color).to eql("B")
    end
    
    it "has an instance varable for text representation" do
      white = Pawn.new('W')
      black = Pawn.new('B')
      expect(white.txt).to eql("\u2659")
      expect(black.txt).to eql("\u265F")
    end
    
    it "has an instance variable for position (default is nil)" do
      expect(subject.pos).to be_nil
    end
    
    it "has an instance variable for movement increments (array length > 0)" do
      expect(subject.increments).to be_kind_of(Array)
      expect(subject.increments.length).to eql(4)
    end
    
  end
end


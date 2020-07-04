require './lib/board.rb'
Dir["./lib/pieces/*"].each {|file| require file }

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

  describe "#set_pos" do

    it "changes a hash value in @cells" do
      subject.set_pos(['c', 7], 1)
      expect(subject.cells[['c', 7]]).to eql(1)
    end

    it "returns nil if the position doesnt exist" do
      test = subject.set_pos(['j', 9], 1)
      expect(test).to be_nil
    end

  end

  describe "#get_pos" do

    it "returns the value of a key in @cells" do
      subject.cells[['a', 3]] = 22
      expect(subject.get_pos(['a', 3])).to eql(22)
    end

    it "returns nil if the position doesnt exist" do
      test = subject.get_pos(['z', 3])
      expect(test).to be_nil
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

end

describe Piece do
  subject(:piece) { Piece.new }
  let(:board) { Board.new }

  describe "#initialize" do

    it "creates a piece obj" do
      expect(subject).to be_kind_of(Piece)
    end

    it "can be assgined a color" do
      white = Piece.new('W')
      black = Piece.new('B')
      expect(white.color).to eql('W')
      expect(black.color).to eql('B')
    end

    it "has an instance varable for text representation" do
      white = Piece.new('W')
      black = Piece.new('B')
      expect(white.txt).to eql("W")
      expect(black.txt).to eql("B")
    end

    it "has an instance variable for position (default is nil)" do
      expect(subject.pos).to be_nil
    end

    it "has an instance variable for movement increments (default is empty Array)" do
      expect(subject.increments).to be_kind_of(Array)
      expect(subject.increments.length).to eql(0)
    end
    
  end
end
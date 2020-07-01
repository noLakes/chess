require './lib/chess.rb'
require './lib/pieces.rb'

describe Game do
  subject(:game) { Game.new }

  describe "#initialize" do

    it "creates a game obj" do
      expect(subject).to be_kind_of(Game)
    end

    it "assigns a value to @board" do
      expect(subject.board).not_to be_nil
    end

    it "assigns values to @players" do
      expect(subject.players).not_to be_nil
    end

    it "assigns a value to turn" do
      expect(subject.turn).not_to be_nil
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

    it "starts with '[ ]' values" do
      expect(test_board.values).to all(match('[ ]'))
    end

    it "has keys named according to algebraic chess notation" do
      expect(test_board.has_key?('a5')).to be_truthy
      expect(test_board.has_key?('g8')).to be_truthy
      expect(test_board.has_key?('h1')).to be_truthy
    end
  end

  describe "#set_pos" do

    it "changes a hash value in @board" do
      subject.set_pos('c7', 1)
      expect(subject.board['c7']).to eql(1)
    end

    it "returns nil if the position doesnt exist" do
      test = subject.set_pos('j9', 1)
      expect(test).to be_nil
    end

  end

  describe "#get_pos" do

    it "returns the value of a key in @board" do
      subject.board['a3'] = 22
      expect(subject.get_pos('a3')).to eql(22)
    end

    it "returns nil if the position doesnt exist" do
      test = subject.get_pos('z3')
      expect(test).to be_nil
    end
  end

  describe "#check_pos" do

    it "returns true if a position exists on the board" do
      expect(subject.check_pos('e8')).to be_truthy
      expect(subject.check_pos('c2')).to be_truthy
      expect(subject.check_pos('g4')).to be_truthy
    end

    it "returns false if a position does not exist on the board" do
      expect(subject.check_pos('a0')).to be_falsey
      expect(subject.check_pos('q10')).to be_falsey
      expect(subject.check_pos('m2')).to be_falsey
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


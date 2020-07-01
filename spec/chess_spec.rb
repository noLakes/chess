require './lib/chess.rb'

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

    it "starts with nil values" do
      expect(test_board.values).to all(be_nil)
    end

    it "has keys named according to algebraic chess notation" do
      expect(test_board.has_key?('a5')).to be_truthy
      expect(test_board.has_key?('g8')).to be_truthy
      expect(test_board.has_key?('h1')).to be_truthy
    end
  end
end
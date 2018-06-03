describe Jylis::DataType::TREG::Result do
  let(:treg_result) { Jylis::DataType::TREG::Result.new(value, timestamp) }
  let(:value)       { 72.1 }
  let(:timestamp)   { 100 }

  describe "interface" do
    specify { treg_result.should respond_to(:value) }
    specify { treg_result.should respond_to(:timestamp) }
    specify { treg_result.should respond_to(:==) }
    specify { treg_result.should respond_to(:to_a) }
  end

  it "initializes correctly" do
    treg_result.value.should eq value
    treg_result.timestamp.should eq timestamp
  end

  it "can parse a result" do
    result = [value, timestamp]

    treg_result = Jylis::DataType::TREG::Result.parse(result)

    treg_result.value.should eq value
    treg_result.timestamp.should eq timestamp
  end

  it "can be compared for equality" do
    other_result = Jylis::DataType::TREG::Result.new(value, timestamp)

    treg_result.should eq other_result

    other_result = Jylis::DataType::TREG::Result.new("bogus", 1)

    treg_result.should_not eq other_result
  end

  specify "to_a reconstructs the raw result returned by the database" do
    expected = [value, timestamp]

    treg_result.to_a.should eq expected
  end
end

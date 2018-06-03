describe Jylis::DataType::TLOG::Row do
  let(:tlog_result) { Jylis::DataType::TLOG::Row.new(value, timestamp) }
  let(:value)       { 72.1 }
  let(:timestamp)   { 100 }

  describe "interface" do
    specify { tlog_result.should respond_to(:value) }
    specify { tlog_result.should respond_to(:timestamp) }
    specify { tlog_result.should respond_to(:==) }
    specify { tlog_result.should respond_to(:to_a) }
  end

  it "initializes correctly" do
    tlog_result.value.should eq value
    tlog_result.timestamp.should eq timestamp
  end

  it "can parse a result" do
    result = [value, timestamp]

    tlog_result = Jylis::DataType::TLOG::Row.parse(result)

    tlog_result.value.should eq value
    tlog_result.timestamp.should eq timestamp
  end

  it "can be compared for equality" do
    other_result = Jylis::DataType::TLOG::Row.new(value, timestamp)

    tlog_result.should eq other_result

    other_result = Jylis::DataType::TLOG::Row.new("bogus", 1)

    tlog_result.should_not eq other_result
  end

  specify "to_a reconstructs the raw result returned by the database" do
    expected = [value, timestamp]

    tlog_result.to_a.should eq expected
  end
end

describe Jylis::DataType::TLOG::Row do
  let(:tlog_result) { Jylis::DataType::TLOG::Row.new(value, timestamp) }
  let(:value)       { 72.1 }
  let(:timestamp)   { 1528238308 }
  let(:iso8601)     { "2018-06-05T22:38:28Z" }

  describe "interface" do
    specify { tlog_result.should respond_to(:value) }
    specify { tlog_result.should respond_to(:timestamp) }
    specify { tlog_result.should respond_to(:==) }
    specify { tlog_result.should respond_to(:to_a) }
    specify { tlog_result.should respond_to(:time) }
    specify { tlog_result.should respond_to(:timestamp_iso8601) }
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

  it "returns a Time object" do
    tlog_result.time.should be_a Time
    tlog_result.time.should eq Time.at(timestamp)
  end

  it "returns an iso8601 timestamp" do
    tlog_result.timestamp_iso8601.should eq iso8601
  end
end

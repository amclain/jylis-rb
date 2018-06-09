describe Jylis::DataType::TLOG::Result do
  let(:tlog_class)  { Jylis::DataType::TLOG::Result }
  let(:tlog_result) { Jylis::DataType::TLOG::Result.parse(raw_rows) }
  let(:raw_rows) {[
    [68, 1],
    [70, 2],
  ]}

  describe "interface" do
    specify { tlog_class.should respond_to(:parse) }

    specify { tlog_result.should respond_to(:[]) }
    specify { tlog_result.should respond_to(:count) }
    specify { tlog_result.should respond_to(:empty?) }
    specify { tlog_result.should respond_to(:to_a) }
  end

  it "can parse a result" do
    tlog_result[0].value.should eq 68
    tlog_result[0].timestamp.should eq 1
    tlog_result[1].value.should eq 70
    tlog_result[1].timestamp.should eq 2
  end

  it "is enumerable" do
    tlog_result.should be_kind_of Enumerable

    tlog_result.each.should be_a Enumerable
  end

  specify "[]" do
    tlog_result[0].value.should eq 68
  end

  specify "count" do
    tlog_result.count.should eq 2
  end

  specify "empty?" do
    tlog_result.empty?.should eq false

    tlog_class.new([]).empty?.should eq true
  end

  specify "to_a reconstructs the raw result returned by the database" do
    tlog_result.to_a.should eq raw_rows
  end
end

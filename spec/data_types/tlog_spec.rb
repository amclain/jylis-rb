describe Jylis::DataType::TLOG do
  let(:tlog)       { Jylis::DataType::TLOG.new(connection) }
  let(:connection) { OpenStruct.new }
  let(:key)        { "temperature" }
  let(:value)      { 72 }
  let(:timestamp)  { 100 }
  let(:count)      { 20 }

  describe "interface" do
    specify { tlog.should respond_to(:get) }
    specify { tlog.should respond_to(:ins) }
    specify { tlog.should respond_to(:size) }
    specify { tlog.should respond_to(:cutoff) }
    specify { tlog.should respond_to(:trimat) }
    specify { tlog.should respond_to(:trim) }
    specify { tlog.should respond_to(:clr) }
  end

  specify "get" do
    connection.should_receive(:query).with("TLOG", "GET", key) {[
      [68, 1],
      [70, 2],
    ]}

    result = tlog.get(key)

    result.should be_a Jylis::DataType::TLOG::Result
    
    result[0].value.should eq 68
    result[0].timestamp.should eq 1
    result[1].value.should eq 70
    result[1].timestamp.should eq 2
  end

  specify "ins" do
    connection.should_receive(:query).with("TLOG", "INS", key, value, timestamp) {
      "OK"
    }

    tlog.ins(key, value, timestamp)
  end

  specify "ins failed" do
    connection.should_receive(:query).with("TLOG", "INS", key, value, timestamp) {
      ""
    }

    expect { tlog.ins(key, value, timestamp) }.to raise_error StandardError
  end

  specify "size" do
    connection.should_receive(:query).with("TLOG", "SIZE", key) { 50 }

    tlog.size(key).should eq 50
  end

  specify "cutoff" do
    connection.should_receive(:query).with("TLOG", "CUTOFF", key) { 25 }

    tlog.cutoff(key).should eq 25
  end

  specify "trimat" do
    connection.should_receive(:query).with("TLOG", "TRIMAT", key, timestamp) {
      "OK"
    }

    tlog.trimat(key, timestamp)
  end

  specify "trimat failed" do
    connection.should_receive(:query).with("TLOG", "TRIMAT", key, timestamp) {
      ""
    }

    expect { tlog.trimat(key, timestamp) }.to raise_error StandardError
  end

  specify "trim" do
    connection.should_receive(:query).with("TLOG", "TRIM", key, count) {
      "OK"
    }

    tlog.trim(key, count)
  end

  specify "trim failed" do
    connection.should_receive(:query).with("TLOG", "TRIM", key, count) {
      ""
    }

    expect { tlog.trim(key, count) }.to raise_error StandardError
  end

  specify "clr" do
    connection.should_receive(:query).with("TLOG", "CLR", key) { "OK" }

    tlog.clr(key)
  end

  specify "clr failed" do
    connection.should_receive(:query).with("TLOG", "CLR", key) { "" }

    expect { tlog.clr(key) }.to raise_error StandardError
  end
end

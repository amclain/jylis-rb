describe Jylis::DataType::TLOG do
  let(:tlog)       { Jylis::DataType::TLOG.new(connection) }
  let(:connection) { OpenStruct.new }
  let(:key)        { "temperature" }
  let(:value)      { 72 }
  let(:count)      { 20 }
  let(:timestamp)  { 1528238308 }
  let(:iso8601)    { "2018-06-05T22:38:28Z" }

  describe "interface" do
    specify { tlog.should respond_to(:get) }
    specify { tlog.should respond_to(:ins) }
    specify { tlog.should respond_to(:size) }
    specify { tlog.should respond_to(:cutoff) }
    specify { tlog.should respond_to(:trimat) }
    specify { tlog.should respond_to(:trim) }
    specify { tlog.should respond_to(:clr) }
  end

  describe "get" do
    specify "without count" do
      connection.should_receive(:query).with("TLOG", "GET", key) {[
        [68, 1],
        [70, 2],
      ]}

      result = tlog.get(key)

      result.should be_a Jylis::DataType::TLOG::Result
      result.count.should eq 2

      result[0].value.should eq 68
      result[0].timestamp.should eq 1
      result[1].value.should eq 70
      result[1].timestamp.should eq 2
    end

    specify "with count" do
      count = 1

      connection.should_receive(:query).with("TLOG", "GET", key, count) {[
        [68, 1],
      ]}

      result = tlog.get(key, count)

      result.should be_a Jylis::DataType::TLOG::Result
      result.count.should eq count

      result[0].value.should eq 68
      result[0].timestamp.should eq 1
    end
  end

  describe "ins" do
    specify do
      connection.should_receive(:query).with("TLOG", "INS", key, value, timestamp) {
        "OK"
      }

      tlog.ins(key, value, timestamp)
    end

    specify "failed" do
      connection.should_receive(:query).with("TLOG", "INS", key, value, timestamp) {
        ""
      }

      expect { tlog.ins(key, value, timestamp) }.to raise_error StandardError
    end

    specify "with iso8601 timestamp" do
      connection.should_receive(:query).with("TLOG", "INS", key, value, timestamp) {
        "OK"
      }

      tlog.ins(key, value, iso8601)
    end
  end

  specify "size" do
    connection.should_receive(:query).with("TLOG", "SIZE", key) { 50 }

    tlog.size(key).should eq 50
  end

  specify "cutoff" do
    connection.should_receive(:query).with("TLOG", "CUTOFF", key) { 25 }

    tlog.cutoff(key).should eq 25
  end

  describe "trimat" do
    specify do
      connection.should_receive(:query).with("TLOG", "TRIMAT", key, timestamp) {
        "OK"
      }

      tlog.trimat(key, timestamp)
    end

    specify "failed" do
      connection.should_receive(:query).with("TLOG", "TRIMAT", key, timestamp) {
        ""
      }

      expect { tlog.trimat(key, timestamp) }.to raise_error StandardError
    end

    specify "with iso8601 timestamp" do
      connection.should_receive(:query).with("TLOG", "TRIMAT", key, timestamp) {
        "OK"
      }

      tlog.trimat(key, iso8601)
    end
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

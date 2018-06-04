describe Jylis::DataType::UJSON do
  let(:ujson)       { Jylis::DataType::UJSON.new(connection) }
  let(:connection)  { OpenStruct.new }
  let(:key)         { "fruit" }
  let(:key2)        { "apple" }
  let(:value)       { "green" }
  let(:result_json) { Oj.dump(values) }
  let(:values)      {{
    "apple"    => "red",
    "banana"   => "yellow",
    "cucumber" => "green",
  }}

  describe "interface" do
    specify { ujson.should respond_to(:get) }
    specify { ujson.should respond_to(:set) }
    specify { ujson.should respond_to(:clr) }
    specify { ujson.should respond_to(:ins) }
    specify { ujson.should respond_to(:rm) }
  end

  describe "get" do
    specify do
      connection.should_receive(:query).with("UJSON", "GET", key) { result_json }

      result = ujson.get(key)

      result.should eq values
    end

    specify "returns an empty string if no value is present" do
      connection.should_receive(:query).with("UJSON", "GET", key) { "" }

      result = ujson.get(key)

      result.should eq ""
    end

    it "raises an error if no keys are provided" do
      connection.should_not_receive(:query)

      expect { ujson.get }.to raise_error ArgumentError
    end
  end

  describe "set" do
    specify do
      connection.should_receive(:query).with("UJSON", "SET", key, key2, result_json) {
        "OK"
      }

      ujson.set(key, key2, values)
    end

    it "raises an error if the result failed" do
      connection.should_receive(:query).with("UJSON", "SET", key, key2, result_json) {
        ""
      }

      expect { ujson.set(key, key2, values) }.to raise_error StandardError
    end

    it "raises error unless at least one key and the value are provided" do
      connection.should_not_receive(:query)

      expect { ujson.set("foo") }.to raise_error ArgumentError
    end
  end

  describe "clr" do
    specify do
      connection.should_receive(:query).with("UJSON", "CLR", key) { "OK" }

      ujson.clr(key)
    end

    it "raises an error if the result failed" do
      connection.should_receive(:query).with("UJSON", "CLR", key) { "" }

      expect { ujson.clr(key) }.to raise_error StandardError
    end

    it "raises an error if no keys are provided" do
      connection.should_not_receive(:query)

      expect { ujson.clr }.to raise_error ArgumentError
    end
  end

  describe "ins" do
    specify do
      connection.should_receive(:query).with("UJSON", "INS", key, result_json) {
        "OK"
      }

      ujson.ins(key, values)
    end

    it "raises an error if the result failed" do
      connection.should_receive(:query).with("UJSON", "INS", key, result_json) {
        ""
      }

      expect { ujson.ins(key, values) }.to raise_error StandardError
    end

    it "raises error unless at least one key and the value are provided" do
      connection.should_not_receive(:query)

      expect { ujson.ins("foo") }.to raise_error ArgumentError
    end
  end

  describe "rm" do
    specify do
      connection.should_receive(:query).with("UJSON", "RM", key, result_json) {
        "OK"
      }

      ujson.rm(key, values)
    end

    it "raises an error if the result failed" do
      connection.should_receive(:query).with("UJSON", "RM", key, result_json) {
        ""
      }

      expect { ujson.rm(key, values) }.to raise_error StandardError
    end

    it "raises error unless at least one key and the value are provided" do
      connection.should_not_receive(:query)

      expect { ujson.rm("foo") }.to raise_error ArgumentError
    end
  end
end

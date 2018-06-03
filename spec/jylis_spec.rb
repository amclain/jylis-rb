describe Jylis do
  let(:server_name) { "db" }
  let(:server_port) { 6379 }
  let(:server_uri)  { "jylis://#{server_name}:#{server_port}" }
  let(:connection)  { Jylis::Connection.new(server_uri) }

  let(:hiredis_mock) { OpenStruct.new(connected?: true) }

  def expect_hiredis_connection
    Hiredis::Connection.should_receive(:new).exactly(:once) { hiredis_mock }
    hiredis_mock.should_receive(:connect).with(server_name, server_port).exactly(:once)
  end

  before { Jylis.current = nil }

  specify "can't be instantiated" do
    Jylis.should_not respond_to(:new)
  end

  describe "current connection" do
    before { expect_hiredis_connection }

    specify "can be set and get" do
      Jylis.current = connection
      Jylis.current.should eq connection
    end
  end

  describe "connect" do
    specify "when not connected" do
      expect_hiredis_connection

      Jylis.current.should eq nil

      Jylis.connect(server_uri)
        .should be_a Jylis::Connection

      Jylis.current.should be_a Jylis::Connection
    end

    specify "when already connected" do
      Hiredis::Connection.should_receive(:new).exactly(:twice) { hiredis_mock }
      hiredis_mock.should_receive(:connect).with(server_name, server_port).exactly(:twice)
      Jylis.current.should eq nil

      Jylis.current = connection

      hiredis_mock.should_receive(:disconnect).exactly(:once)

      Jylis.connect(server_uri)
        .should be_a Jylis::Connection

      Jylis.current.should be_a Jylis::Connection
      Jylis.current.should_not eq connection
    end
  end

  describe "forwarded methods" do
    specify { Jylis.should respond_to(:connected?) }
    specify { Jylis.should respond_to(:reconnect) }
    specify { Jylis.should respond_to(:disconnect) }
    specify { Jylis.should respond_to(:query) }
  end
end

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

  before { expect_hiredis_connection }

  describe "current connection" do
    specify "can be set and get" do
      Jylis.current = connection
      Jylis.current.should eq connection
    end
  end
end

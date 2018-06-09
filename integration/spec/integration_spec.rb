describe "integration tests" do
  def start_server
    system("docker-compose", "-f", "docker/docker-compose.yml", "up", "-d")
  end

  def stop_server
    system("docker-compose", "-f", "docker/docker-compose.yml", "down")
  end

  def reset_server
    stop_server
    start_server
  end

  before do
    reset_server
    Jylis.connect("jylis://localhost")
  end

  after       { Jylis.disconnect if Jylis.connected? }
  after(:all) { stop_server }

  specify ""
end

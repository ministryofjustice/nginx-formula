require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

platform = os[:family]

describe "nginx dependencies" do
  packages = %w(apache2-utils netcat-traditional)
  packages.each do |pkg|
    it "package #{pkg} is installed" do
      expect(package(pkg)).to be_installed
    end
  end
end

describe "nginx setup" do
  state = {
    "ubuntu"  => {
      "pkg"   => "nginx-full",
      "svc"   => "nginx",
      "user"  => "nginx",
      "group" => "nginx"
    }
  }

  it "package #{state[platform]["pkg"]} is installed on platform #{platform}" do
    expect(package(state[platform]["pkg"])).to be_installed
  end

  it "service #{state[platform]["svc"]} should be running" do
    expect(service(state[platform]["svc"])).to be_enabled
    expect(service(state[platform]["svc"])).to be_running
  end

  it "user #{state[platform]["user"]}" do
    groups = %W(webservice www-data #{state[platform]["group"]})

    expect(user(state[platform]["user"])).to exist
    expect(user(state[platform]["user"])).to have_home_directory('/var/cache/nginx')
    expect(user(state[platform]["user"])).to have_login_shell('/sbin/nologin')
    groups.each do |g|
      expect(user(state[platform]["user"])).to belong_to_group(g)
    end
  end
  
end

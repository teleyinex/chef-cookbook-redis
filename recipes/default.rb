execute "download Redis-server" do
    command "wget http://download.redis.io/releases/redis-2.8.2.tar.gz"
    cwd "/usr/local/src"
end

execute "uncompress redis-server" do
    command "tar xvzf redis-2.8.2.tar.gz"
    cwd "/usr/local/src"
end

execute "compile redis-server" do
    command "make"
    cwd "/usr/local/src/redis-2.8.2"
end

execute "install redis-server" do
    command "make install"
    cwd "/usr/local/src/redis-2.8.2"
end

execute "install redis-sentinel" do
    command "cp src/redis-sentinel /usr/local/bin"
    cwd "/usr/local/src/redis-2.8.2"
end

directory "/etc/redis" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

user "redis" do
  comment "Redis User"
end

template "/etc/redis/redis.conf" do
  source "redis.conf.erb"
  mode 0660
  owner "redis"
  group "root"
end

template "/etc/redis/sentinel.conf" do
  source "sentinel.conf.erb"
  mode 0660
  owner "redis"
  group "root"
end

template "/etc/init.d/redis-server" do
  source "redis-server.erb"
  mode 755
  owner "root"
  group "root"
end

template "/etc/init.d/redis-sentinel" do
  source "redis-sentinel.erb"
  mode 755
  owner "root"
  group "root"
end

execute "Start redis-server" do
    command "/etc/init.d/redis-server start"
end

execute "Start redis-sentinel" do
    command "/etc/init.d/redis-sentinel start"
end

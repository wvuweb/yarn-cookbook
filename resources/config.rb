require 'etc'

resource_name :yarn_config

property :user, String
property :user_home, [String, nil], default: nil
property :command, String, default: nil
property :config_key, String, default: nil
property :config_value, String, default: nil

default_action :run

action :run do
  user_group = ::Etc.getgrgid(::Etc.getpwnam(new_resource.user).gid).name
  user_home = new_resource.user_home
  if user_home.nil?
    user_home = ::Etc.getpwnam(new_resource.user).dir
  end

  run_command = "yarn config #{new_resource.comamnd} #{new_resource.config_key} #{new_resource.config_value}"

  execute "execute yarn config at `#{new_resource.dir}`" do
    command run_command
    cwd new_resource.dir
    user new_resource.user
    group user_group
    environment(
      'HOME' => user_home,
      'USER' => new_resource.user
    )
    action :run
  end
end

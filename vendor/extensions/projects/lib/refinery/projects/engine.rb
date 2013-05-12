module Refinery
  module Projects
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Projects

      engine_name :refinery_projects

      initializer "register refinerycms_projects plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "projects"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.projects_admin_projects_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/projects/project'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Projects)
      end
    end
  end
end

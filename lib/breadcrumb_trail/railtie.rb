module BreadcrumbTrail
  class Railtie < Rails::Railtie
    initializer "breadcrumb_trail.modify_controller" do
      ActiveSupport.on_load :action_controller do
        include BreadcrumbTrail::ActionController
      end
    end
  end
end

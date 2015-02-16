module BreadcrumbTrail

  # A railtie, to load the plugin when Rails is initialized.
  class Railtie < Rails::Railtie
    initializer "breadcrumb_trail.modify_controller" do
      ActiveSupport.on_load :action_controller do
        include BreadcrumbTrail::ActionController
      end
    end
  end
end

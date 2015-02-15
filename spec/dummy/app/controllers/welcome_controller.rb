class WelcomeController < ApplicationController

  def index
    breadcrumb(name: "here") { root_path }
  end
end

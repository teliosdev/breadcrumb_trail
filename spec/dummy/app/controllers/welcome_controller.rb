class WelcomeController < ApplicationController

  def index
    breadcrumb(name: "here") { root_path }
  end

  def hello
    breadcrumb(name: "here") { root_path }
    breadcrumb(name: "world") { "/world" }
  end
end

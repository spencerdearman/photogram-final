class HomeController < ApplicationController
  def index
    @users = User.order(:username)
  end
end

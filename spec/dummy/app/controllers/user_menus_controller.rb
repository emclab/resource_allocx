class UserMenusController < ApplicationController
  def index
    session[:page_step] = 1
    session[:page1] = user_menus_path
     
    render 'user_menus/index'
  end
end

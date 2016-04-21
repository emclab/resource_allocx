class ApplicationController < ActionController::Base
  include Authentify::AuthentifyUtility
    
  protect_from_forgery
  
  before_action :set_local_thread_variables
  after_action :cleanup_local_thread_variables 
end

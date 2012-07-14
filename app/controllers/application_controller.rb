# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end

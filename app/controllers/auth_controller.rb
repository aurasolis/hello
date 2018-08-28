class AuthController < ApplicationController
  include AuthHelper

  def show
    @token = get_token_from_code params[:code]
    #session[:azure_token] = token.to_hash
    @user = user_info(@token.token)
  end


end

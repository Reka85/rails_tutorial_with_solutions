class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # login and go to show page
    else
      # create error message
      flash[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end
end

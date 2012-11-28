class UsersController < ApplicationController
  def new
  	@user = User.new(params[:user])
  end

  def show
  	@user= User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "N4, you're in!"
      if @user.name == "Emily Mah"
        flash[:success] = "Welcome to the site, babe!" end  
      redirect_to @user
    else 
      render 'new'
    end
  end



end

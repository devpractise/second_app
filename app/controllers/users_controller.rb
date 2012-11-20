class UsersController < ApplicationController
  def new
  	@user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end

  def show
  	@user= User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "N4, you're in!"
      if @user.name == "Emily Mah"
        flash[:success] = "Welcome to the site, babe!" end
      redirect_to @user
    else 
      render 'new'
    end
  end

end

class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy] 
  #Because before_filter applies to all actions,
  #we use 'only:' to specify that it should only apply to edit and update actions.
  before_filter :correct_user, only: [:edit, :update]

  before_filter :admin_user, only: :destroy

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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit

  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      redirect_to @user
      flash[:success] = "Profile updated"
    else
      render 'edit'
    end
  end
  private
    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end



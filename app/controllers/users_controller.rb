class UsersController < ApplicationController
  before_action :set_params, only: [:show, :edit, :update, :followings, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :logged_in?, excpect: [:new, :create]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def edit
    # correct_userを呼び出すため、以下は不要
    # @user = User.find(params[:id])
  end
  
  def update
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  # フォローしているユーザー
  def followings
    @title = "Following"
    @users = @user.following_users
    render 'show_follow'
  end
    
  # フォローされているユーザー
  def followers
    @title = "Followers"
    @users = @user.follower_users
    render 'show_follow'    
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :location, :password,
                                 :password_confirmation)
  end

  def set_params
     @user = User.find(params[:id])
  end

  def correct_user
    redirect_to(root_path) if @user != current_user
  end
end

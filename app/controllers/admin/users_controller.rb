class Admin::UsersController < ApplicationController
	before_filter :authenticate_user!
  before_filter :admin_user

	def index
		@users = User.all
	end

	def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user]) && create_plan(@user)
      flash[:success] = "User #{@user.username} updated"
      redirect_to admin_users_path
    else
    	flash[:error] = "User #{@user.username} could not be approved"
      redirect_to admin_users_path
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to admin_users_path
  end

	private
		def admin_user
	    redirect_to 'signout' && flash_error unless current_user.admin?
	  end

	  def create_plan(user)
	  	user.plan = Plan.new(:permalink => user.username)
    	user.save!
    end

    def flash_error
      flash[:error] = "You are not logged in as the correct user"
    end
end

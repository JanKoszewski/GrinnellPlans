class Admin::UsersController < ApplicationController
	before_filter :authenticate_user!
  before_filter :ensure_admin_user

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
      unless current_user.admin?
        redirect_to root_path
        flash[:error] = "You are not logged in as the correct user"
      end
	  end

	  def create_plan(user)
	  	user.plan = Plan.new(:permalink => user.username)
    	user.save!
    end
end

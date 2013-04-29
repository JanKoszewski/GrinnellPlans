class SubscriptionsController < ApplicationController
	def update
		followed_user = User.find(params[:followed_user_id])
		if followed_user.update_attributes(params[:user])
      flash[:success] = "Subscription level updated"
      redirect_to :back
    else
    	flash[:error] = "User #{@user.username} could not be approved"
      redirect_to :back
    end
	end

	def create
    followed_user = User.find(params[:followed_user_id])
    current_user.subscriptions.create(followed_user_id: params[:followed_user_id])
    redirect_to :back, :notice => "You've subscribed to #{followed_user.username}'s plan! Way to go there!"
  end

  def destroy
    sub = current_user.subscriptions.find(params[:id])
    sub.destroy
    redirect_to :back
  end
end

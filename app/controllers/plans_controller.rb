class PlansController < ApplicationController
	before_filter :ensure_plan_ownership, :only => [:edit, :update]

	def index
	end

	def show
		@plan = Plan.find_by_permalink(params[:id])
		Subscription.mark_plan_as_read(current_user.id, @plan.user.id)
	end

	def edit
		@plan = current_user.plan
	end

	def update
    @plan = current_user.plan
    if @plan.update_attributes(params[:plan])
      redirect_to plan_path(current_user.username)
    else
      render :action => "edit"
    end
  end

  private
  	def ensure_plan_ownership
  		unless current_user.plan == Plan.find_by_permalink(params[:id])
  			redirect_to root_path
        flash[:error] = "Unauthorized action"
  		end
  	end
end

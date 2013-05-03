class PlansController < ApplicationController
	before_filter :ensure_plan_ownership, :only => [:edit, :update]

	def index
    @plans = Plan.all
	end

	def show
		@plan = Plan.find_by_permalink(params[:id])
		Subscription.mark_plan_as_read(current_user.id, @plan.user.id)
    Mention.mark_plan_as_read(current_user.id, @plan.user.id)
	end

	def edit
		@plan = current_user.plan
	end

	def update
    @plan = current_user.plan
    if sanitize_input_markup(params[:plan]) && @plan.calculate_previous_length && @plan.update_attributes(params[:plan])
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

    def sanitize_input_markup(submitted_plans_data)
      replace_date_markup(submitted_plans_data)
      submitted_plans_data
    end

    def replace_date_markup(submitted_plans_data)
      submitted_plans_data["body"].gsub!(/.*?\[date\].*?/s, "<b>#{Time.now.strftime('%A %B %e, %Y %l:%M %P')}</b>")
    end
end

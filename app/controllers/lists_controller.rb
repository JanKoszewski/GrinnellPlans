class ListsController < ApplicationController
	before_filter :ensure_lists_ownership

	def index
		@lists = User.find(params[:user_id]).lists
	end

	def edit
	end

	def show
	end

	def update
	end

	def create
	end

	def destroy
	end

  private 
  	def ensure_lists_ownership
  		unless params[:user_id].to_i == current_user.id
  			redirect_to root_path
  			flash[:error] = "Unauthorized action"
  		end
  	end
end
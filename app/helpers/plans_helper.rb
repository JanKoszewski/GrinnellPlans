module PlansHelper
	def current_subscription
		current_user.subscriptions.find_by_followed_user_id(@plan.user.id)
	end
end

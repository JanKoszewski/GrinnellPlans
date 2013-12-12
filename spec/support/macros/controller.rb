module Support
  module Macros
    module Controller

      def login_user
        before(:each) do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          @user = FactoryGirl.create(:user)
          @user.plan = Plan.new(:permalink => @user.username)
          sign_in(@user)
        end
      end

    end
  end
end

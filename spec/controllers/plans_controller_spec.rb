require 'spec_helper'

describe PlansController do
  login_user

  describe "#show" do
    context "with a a valid username" do
      it "returns successfully" do
        get :show, id: @user.username

        response.should be_success
      end
    end

    context "without a valid username" do
      it "redirects to plans#index" do
        get :show, :id => "invalidusername"

        response.should redirect_to root_path
      end
    end
  end
end

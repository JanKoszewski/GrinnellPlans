require 'spec_helper'

describe PlansController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @user.plan = Plan.new(:permalink => @user.username)
    sign_in @user
  end

  it "redirects to login when no user present" do
    get :show, :id => @user.username

    raise response.inspect
    response.should be_success
  end
end

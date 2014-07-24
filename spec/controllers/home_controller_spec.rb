require 'spec_helper'

describe HomeController do
  let (:user)  {create :user }

  render_views

  describe "GET index" do
    it "shows frontpage page when not signed in" do
      get :index
      expect(response.body).to match 'Your innovation only becomes social when we work together!'
    end
  end
end

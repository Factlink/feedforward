require 'spec_helper'

describe HomeController do
  let (:user)  {create :user }

  render_views

  describe "GET index" do
      get :index

    it "shows in-your-browser page when not signed in" do
      expect(response.body).to match 'Your innovation only becomes social when it is shared!'
    end
  end
end

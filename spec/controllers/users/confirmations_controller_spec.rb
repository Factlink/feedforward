require 'spec_helper'

describe Users::ConfirmationsController do
  before do
    # Tests don't pass through the router; see https://github.com/plataformatec/devise
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe :show do
    render_views

    it "confirms the user and redirects to setup page" do
      user = create :user

      get :show, confirmation_token: user.confirmation_token

      user.reload
      expect(user).to be_confirmed

      expect(response).to redirect_to feed_path
    end

    it "works when the user is already signed in" do
      user = create :user

      sign_in(user)

      get :show, confirmation_token: user.confirmation_token

      user.reload
      expect(user).to be_confirmed

      expect(response).to redirect_to feed_path
    end

    it "leaves another user signed in and shows an error" do
      confirmation_user = create :user
      signed_in_user = create :user

      sign_in(signed_in_user)

      get :show, confirmation_token: confirmation_user.confirmation_token

      confirmation_user.reload
      expect(confirmation_user).to_not be_confirmed

      expect(flash[:alert]).to match /already logged in with another account/
    end
  end
end

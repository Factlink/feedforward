class Api::GroupsController < ApplicationController
  pavlov_action :create, Interactors::Groups::Create
  pavlov_action :update, Interactors::Groups::Update
  pavlov_action :delete, Interactors::Groups::Delete
  pavlov_action :index, Interactors::Groups::List
  pavlov_action :add_member, Interactors::Groups::AddMember
  pavlov_action :remove_member, Interactors::Groups::RemoveMember
  pavlov_action :feed, Interactors::Groups::Feed
end

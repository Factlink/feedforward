module Backend
  module Groups
    extend self
    def create(groupname:, usernames:)
      group = Group.new
      group.groupname = groupname
      group.users << User.where(username: usernames)
      group.save!
      dead(group)
    end

    def add_member(username:, group_id:)
      user = Users.user_by_username username: username
      group = Group.find_by! id: group_id
      group.users << user
      group.save!
    end

    def remove_member(username:, group_id:)
      user = Users.user_by_username username: username
      group = Group.find_by! id: group_id
      group.users.delete user
    end

    def update(group_id:, groupname:)
      group = Group.find_by! id: group_id
      group.groupname = groupname
      group.save!
    end

    def delete(group_id:)
      group = Group.find_by! id: group_id
      group.destroy!
    end

    private

    def dead(group)
      DeadGroup.new(id: group.id, groupname: group.groupname)
    end

  end
end

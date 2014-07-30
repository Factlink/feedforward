module Interactors
  module Groups
    class Update
      include Pavlov::Interactor
      include Util::CanCan

      attribute :id
      attribute :groupname
      attribute :pavlov_options, Hash

      def authorized?
        pavlov_options[:import] || can?(:update, Group)
      end

      private

      def execute
        Backend::Groups.update(
            group_id: id,
            groupname: groupname
        )
      end

      def validate
        validate_nonempty_string :groupname, groupname
        validate_integer_string :id, id
      end
    end
  end
end

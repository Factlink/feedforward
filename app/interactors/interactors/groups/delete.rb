module Interactors
  module Groups
    class Delete
      include Pavlov::Interactor
      include Util::CanCan

      attribute :id
      attribute :pavlov_options, Hash

      def authorized?
        pavlov_options[:import] || can?(:destroy, Group)
      end

      private

      def execute
        Backend::Groups.delete group_id: id
      end

      def validate
        validate_integer_string :id, id
      end
    end
  end
end

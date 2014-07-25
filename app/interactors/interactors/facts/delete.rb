module Interactors
  module Facts
    class Delete
      include Pavlov::Interactor

      attribute :id, String
      attribute :pavlov_options, Hash

      def authorized?
        pavlov_options[:current_user].admin? ||
            FactData.where(fact_id: id).first.created_by_id == pavlov_options[:current_user].id
      end

      private

      def execute
        Backend::Facts.destroy!(fact_id: id)
      end

      def validate
        validate_integer_string :fact_id, id
      end
    end
  end
end

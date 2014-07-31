module Interactors
  module Facts
    class Update
      include Pavlov::Interactor
      include Util::CanCan

      attribute :displaystring, String
      attribute :site_url, String
      attribute :site_title, String
      attribute :id, String
      attribute :group_id, Integer, default: nil
      attribute :pavlov_options, Hash
      attribute :resolved, Boolean

      def authorized?
        pavlov_options[:current_user].admin? ||
          FactData.where(fact_id: id).first.created_by_id == pavlov_options[:current_user].id
      end

      private

      def execute
        dead_fact = Backend::Facts.update(
            displaystring: displaystring,
            site_url: site_url, site_title: site_title, updated_at: pavlov_options[:time],
            fact_id: id,
            group_id: group_id,
            resolved: resolved
        )

        dead_fact
      end

      def validate
        validate_nonempty_string :displaystring, displaystring
        validate_string :site_title, site_title
        validate_string :site_url, site_url
        validate_integer_string :fact_id, id
      end
    end
  end
end

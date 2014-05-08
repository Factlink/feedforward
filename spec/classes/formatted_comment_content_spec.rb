require 'spec_helper'

describe FormattedCommentContent do
  include ActionView::Helpers::TagHelper

  describe '#html' do
    it 'sanitizes html' do
      formatted_comment = described_class.new '<a>Link</a>'

      expect(formatted_comment.html).to eq '&lt;a&gt;Link&lt;/a&gt;'
      expect(formatted_comment.html).to be_html_safe
    end

  end
end

class FormattedCommentContent
  include ActionView::Helpers::TagHelper

  def initialize text
    @text = text
  end

  def html
    ERB::Util.html_escape(@text).to_str.html_safe
  end
end

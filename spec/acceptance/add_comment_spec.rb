require 'acceptance_helper'

# TODO rename to add_evidence_spec
feature "adding comments to a fact", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  background do
    @user = sign_in_user create :user, :confirmed
  end

  let(:factlink) { create :fact_data }

  scenario 'after adding a comment, the user should be able to reset his opinion' do
    open_discussion_for factlink.fact_id.to_s

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment
    assert_comment_exists comment

    # there is just one factlink in the list
    find('.spec-comment-vote-amount', text: "1")
    find('.spec-comment-vote-up').click
    find('.spec-comment-vote-amount', text: "0")

    open_discussion_for factlink.fact_id.to_s

    find('.spec-comment-vote-amount', text: "0")
  end

  scenario 'comments and comments with links to annotations should be sorted on relevance' do
    open_discussion_for factlink.fact_id.to_s

    comment1 = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment1
    vote_comment :up, comment1 #again, so lower than comment2

    comment2 = 'Geert is een baas'
    add_comment comment2

    open_discussion_for factlink.fact_id.to_s

    #find text with comment - we need to do this before asserting on ordering
    #since expect..to..match is not async, and at this point the comment ajax
    #may not have been completed yet.
    assert_comment_exists comment1

    items = all '.spec-evidence-box'
    expect(items[0].text).to match (Regexp.new comment2)
    expect(items[1].text).to match (Regexp.new comment1)
  end

  scenario "after adding it can be edited and removed" do
    open_discussion_for factlink.fact_id.to_s

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment comment
    assert_comment_exists comment

    open_discussion_for factlink.fact_id.to_s
    assert_comment_exists comment
    edited_comment = 'Nu heeft Gerard een stomme fiets'
    within '.spec-evidence-box' do
      find('.spec-comment-edit').click
      fill_in_comment_textarea edited_comment, original_text: comment
      click_button "Post"
    end
    assert_comment_exists edited_comment

    open_discussion_for factlink.fact_id.to_s
    assert_comment_exists edited_comment

    find('.spec-delete-button-open').click
    click_button 'Delete'

    page.should_not have_content edited_comment

    open_discussion_for factlink.fact_id.to_s

    page.should_not have_content edited_comment
  end
end

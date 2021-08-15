require 'test_helper'

class CommentPolicyTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:carmen_on_alice)
  end

  test 'the author can edit, update and delete their comment' do
    policy = CommentPolicy.new(users(:carmen), @comment)

    assert policy.edit?
    assert policy.update?
    assert policy.destroy?
  end

  test 'the post owner can delete a comment but not reword it' do
    policy = CommentPolicy.new(users(:alice), @comment)

    assert policy.destroy?
    assert_not policy.update?
    assert_not policy.edit?
  end

  test 'a bystander can do nothing to someone else\'s comment' do
    policy = CommentPolicy.new(users(:bruno), @comment)

    assert_not policy.update?
    assert_not policy.destroy?
  end

  test 'commenting needs permission to see the post' do
    hidden = Comment.new(post: posts(:bruno_post), user: users(:alice), comment_body: 'hi')
    visible = Comment.new(post: posts(:alice_post), user: users(:bruno), comment_body: 'hi')

    assert_not CommentPolicy.new(users(:alice), hidden).create?
    assert CommentPolicy.new(users(:bruno), visible).create?
  end
end

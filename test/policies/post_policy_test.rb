require 'test_helper'

class PostPolicyTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
    @bruno = users(:bruno)
    @carmen = users(:carmen)
  end

  test 'anyone signed in can see a post from a public account' do
    assert PostPolicy.new(@bruno, posts(:alice_post)).show?
  end

  test 'a private account hides its posts from people who do not follow it' do
    assert_not PostPolicy.new(@alice, posts(:bruno_post)).show?
    assert_not PostPolicy.new(@alice, posts(:bruno_post)).like?
  end

  test 'followers and the owner can see a private post' do
    Follower.create!(follower_id: @carmen.id, following_id: @bruno.id)

    assert PostPolicy.new(@carmen, posts(:bruno_post)).show?
    assert PostPolicy.new(@bruno, posts(:bruno_post)).show?
  end

  test 'only the owner can edit, update or destroy a post' do
    post = posts(:alice_post)

    %i[edit? update? destroy?].each do |action|
      assert PostPolicy.new(@alice, post).public_send(action), "owner should be allowed to #{action}"
      assert_not PostPolicy.new(@carmen, post).public_send(action), "others must not #{action}"
    end
  end
end

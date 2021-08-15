require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def upload(name, type)
    Rack::Test::UploadedFile.new(file_fixture(name), type)
  end

  test 'accepts a PNG image' do
    post = users(:alice).posts.new(image: upload('tiny.png', 'image/png'))

    assert post.valid?, post.errors.full_messages.to_sentence
  end

  test 'rejects HTML that only pretends to be a PNG' do
    post = users(:alice).posts.new(image: upload('disguised.png', 'image/png'))

    assert_not post.valid?
    assert post.errors[:image].any?
  end

  test 'rejects SVG uploads' do
    post = users(:alice).posts.new(image: upload('drawing.svg', 'image/svg+xml'))

    assert_not post.valid?
    assert post.errors[:image].any?
  end

  test 'requires an image' do
    assert_not users(:alice).posts.new.valid?
  end

  test 'toggle_like_by adds and then removes a like' do
    post = posts(:bruno_post)
    user = users(:carmen)

    assert post.toggle_like_by(user)
    assert_equal 1, post.likes_count
    assert_not post.toggle_like_by(user)
    assert_equal 0, post.likes_count
  end
end

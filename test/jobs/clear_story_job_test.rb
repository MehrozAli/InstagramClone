require 'test_helper'

class ClearStoryJobTest < ActiveJob::TestCase
  test 'hides an expired story' do
    story = posts(:carmen_story)

    ClearStoryJob.perform_now(story.id)

    assert_not story.reload.active
  end

  test 'never hides a regular post' do
    ClearStoryJob.perform_now(posts(:alice_post).id)

    assert posts(:alice_post).reload.active
  end

  test 'a story deleted before it expires is ignored' do
    assert_nothing_raised { ClearStoryJob.perform_now(0) }
  end
end

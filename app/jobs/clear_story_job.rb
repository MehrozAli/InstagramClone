# Hides a story once its lifetime is over.
class ClearStoryJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    Post.areStories.where(id: post_id).update_all(active: false, updated_at: Time.current)
  end
end

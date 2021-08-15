class ClearStoryJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts args[0]
    Post.find_by(id: args[0], post_type: 'story').update(active: false)
  end
end

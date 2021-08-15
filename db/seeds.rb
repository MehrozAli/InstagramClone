# Demo data for local use: fictional people and generated abstract images
# (db/seeds/images). Safe to run more than once.

IMAGES = Rails.root.join('db/seeds/images')
DEMO_PASSWORD = 'pinhole-demo'.freeze

def image(name)
  File.open(IMAGES.join("#{name}.png"))
end

def person(username, first, last, avatar: nil, private: false)
  User.find_or_create_by!(username: username) do |user|
    user.email = "#{username}@pinhole.test"
    user.first_name = first
    user.last_name = last
    user.password = DEMO_PASSWORD
    user.isPrivate = private
    user.profileImg = image(avatar) if avatar
  end
end

def photo(user, name, hours_ago:, type: 'post')
  user.posts.where(post_type: type).find_by(image: "#{name}.png") ||
    user.posts.create!(image: image(name), post_type: type, created_at: hours_ago.hours.ago)
end

demo = person('demo', 'Demo', 'Viewer')
ada = person('ada_darkroom', 'Ada', 'Lindqvist', avatar: 'avatar-teal')
tomas = person('tomas_frames', 'Tomás', 'Reyes', avatar: 'avatar-rust')
mira = person('mira_wanders', 'Mira', 'Osei', avatar: 'avatar-olive', private: true)
person('june_grain', 'June', 'Park')

[ada, tomas].each { |user| Follower.find_or_create_by!(follower: demo, following: user) }
Follower.find_or_create_by!(follower: ada, following: tomas)

dunes = photo(ada, 'dunes', hours_ago: 3)
harbour = photo(tomas, 'harbour', hours_ago: 7)
photo(ada, 'pottery', hours_ago: 30)
photo(tomas, 'forest', hours_ago: 52)
photo(mira, 'tide', hours_ago: 5)
photo(tomas, 'market', hours_ago: 1, type: 'story')

[[dunes, tomas, 'That last ridge line is perfect.'],
 [dunes, demo, 'Which film stock was this?'],
 [harbour, ada, 'Love how flat the water is here.']].each do |post, author, body|
  post.comments.find_or_create_by!(user: author, comment_body: body)
end

[[dunes, tomas], [dunes, demo], [harbour, ada]].each do |post, user|
  post.likes.find_or_create_by!(user: user)
end

puts "Seeded #{User.count} people and #{Post.count} photos. Log in as demo@pinhole.test / #{DEMO_PASSWORD}"

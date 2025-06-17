# db/seeds.rb

# 1. Create (or find) the Rails category
rails_category = Category.find_or_create_by!(name: 'Ruby on Rails') do |c|
  c.display_in_nav = true
end

# 2. Seed some Rails posts, including a body
Post.create!([
  {
    title:           'Getting Started with Ruby on Rails',
    body:            'In this tutorial we’ll cover installation, generators, and your first MVC example in Rails.',
    views:           0,
    user_id:         1,  # adjust this to an existing user ID
    slug:            'getting-started-with-ruby-on-rails',
    comments_count:  0,
    category_id:     rails_category.id
  },
  {
    title:           'Mastering ActiveRecord Associations',
    body:            'Learn how `has_many`, `belongs_to`, `has_one` and `has_many :through` really work under the hood.',
    views:           0,
    user_id:         1,
    slug:            'mastering-activerecord-associations',
    comments_count:  0,
    category_id:     rails_category.id
  },
  {
    title:           'Building APIs with Rails and JWT',
    body:            'Step-by-step guide to creating a secure JSON API in Rails, using JWT for stateless auth.',
    views:           0,
    user_id:         1,
    slug:            'building-apis-with-rails-and-jwt',
    comments_count:  0,
    category_id:     rails_category.id
  }
])

puts "Seeded category: #{rails_category.name} (id=#{rails_category.id})"
puts "Seeded #{Post.where(category: rails_category).count} Rails posts."

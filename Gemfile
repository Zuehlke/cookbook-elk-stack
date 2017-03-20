source 'https://rubygems.org'

gem 'chef', '12.4.1'
gem 'berkshelf', '4.0.1'

# pin for ruby 2.1.5 compatibility
gem 'nio4r', '1.2.1'

group :test do
  gem 'foodcritic', '5.0.0'
  gem 'rubocop', '0.35.1'
  gem 'chefspec', '4.4.0'
end

group :integration do
  gem 'test-kitchen', '1.4.2'
  gem 'kitchen-docker', '2.1.0'
  gem 'kitchen-vagrant', '0.19.0'
  gem 'serverspec', '2.24.3'
end

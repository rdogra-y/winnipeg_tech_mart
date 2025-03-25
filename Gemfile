source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "sprockets-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "sassc-rails"

# ✅ Admin Dashboard
gem "activeadmin"

# ✅ Authentication
gem "devise"

# ✅ Image uploads with variants (for thumbnails, etc.)
gem "image_processing", "~> 1.2"

# ✅ Pagination (for product listings)
gem "kaminari"

# ✅ Seeding with real-looking data
gem "faker"

# ✅ Web scraping
gem "nokogiri"

# ✅ SEO-friendly URLs (optional but nice-to-have)
gem "friendly_id", "~> 5.4.0"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [ :ruby ]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

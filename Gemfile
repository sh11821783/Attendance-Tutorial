source 'https://rubygems.org'

gem 'rails',        '~> 5.1.6'
gem 'rails-i18n' # このi18nの機能により手軽に日本語化対応も可能です。
gem 'bcrypt'
gem 'faker' # このgemは実際に存在していそうな名前を生成してくれる便利なものです。
gem 'bootstrap-sass'
gem 'will_paginate' # 1ページあたりに表示するユーザーの件数を制限します。
gem 'bootstrap-will_paginate' # ページネーションのデザインをお手軽に良くする。
gem 'puma',         '~> 3.7'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
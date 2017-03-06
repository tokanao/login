# Rails 認証系 gem 調査

https://www.ruby-toolbox.com/categories/rails_authentication

---
## 各種共通 Rails プロジェクト作成
```bash
rails new monban2 -d postgresql
cd monban2
rbenv local 2.2.5
rbenv rehash
rbenv exec gem install bundler
rbenv rehash
rbenv exec gem which bundler
```

### DB作成と接続設定
```bash
psql postgres
postgres=# create database monban2  with owner="toka";
vi config/database.yml
```

---
## Monban

### gem 追加
```bash
vi Gemfile
  gem 'monban'
  gem 'monban-generators'

```
```
bundle install --path vendor/bundle
```

### UI/テーブル 作成
```
rails g monban:scaffold
rake db:migrate
```

### ダッシュボード作成
```
rails g controller dashboards show
vi app/controllers/dashboards_controller.rb
  before_action :require_login
```

### ルート追加
```
vi config/routes.rb
root 'dashboards#show'
```

### レイアウト編集してサインイン・サインアップを追加
```
vi app/views/layouts/application_controller.rb
```

rails s   ＃ rails 起動


## Sorcery

- gem 追加と bundle 実行

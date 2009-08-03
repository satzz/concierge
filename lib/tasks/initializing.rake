# -*- coding: utf-8 -*-
# 開発環境および試験環境のデータベースに対して、以下のことを行います。
#   1. データベースを作成する
#   2. 開発環境でマイグレーションを実行する。
#   3. 開発環境にフィクスチャデータを格納する。(db/fixtures/development/ ディレクトリから)
#   4. テスト環境に開発環境のスキーマをコピーする。
# なお、人為的ミスの誘発を避けるため、本番環境のデータベースを準備するタスクはあえて用意していません。
# DBMSにログインして、create database 文でデータベースを作り、
# コンソール上で rake db:migrate RAILS_ENV=production を実行してください。

namespace :db do
  desc "Create the development and test databases."
  task :create do
    require 'yaml'
    
    path = File.dirname(__FILE__) + "/../../config/database.yml"
    configurations = YAML.load_file(path)
    
    %w(development test).each do |env|
      config = configurations[env]
      if config['adapter'] == 'mysql'
        command = sprintf(%{mysql --user %s}, config['username'])
        command += " --password=#{config['password']}" if config['password'] and !config['password'].empty?
        command += " --host #{config['host']}" if config['host'] and !config['host'].empty?
        command += " --port #{config['port']}" if config['port'] and !config['port'].empty?
        sh command + %( --execute="drop database if exists #{config['database']}")
        if config['encoding'] and !config['encoding'].empty?
          sh command + %( --execute="create database #{config['database']} default character set #{config['encoding']}")
        else
          sh command + %( --execute="create database #{config['database']}")
        end
      elsif config['adapter'] == 'postgresql'
        # 未実装
      else
        raise "Unsupported database adapter #{config['adapter']}"
      end
    end
  end
  
  desc "Create and initialize the development and test databases."
  task :initialize => ["db:create", "db:migrate", "db:import:development", "db:test:prepare"]
end

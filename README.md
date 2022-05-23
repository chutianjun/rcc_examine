# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions


* 运行流程介绍

* 1.第一步,将config/database_mysql.example.yml 复制一份 命名为 为 database.yml,这里数据库 使用的是mysql, 文件 database.yml 已经忽略掉 了
拷贝数据库示例文件,修改host,username,password 等 即可

* 2.第二步,

* 运行 rails db:create RAILS_ENV='development' 生成数据库

* 运行 rails db:migrate 生成表结构

* 运行 rails db:seed 填充对应的数据

* 3.第三步,直接在 命令行 运行 rails s ,访问 127.0.0.1:3000 即可
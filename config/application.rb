require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Examine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Auto-load API and its subdirectories
    #
    #
    #
    # 官方 说 rails 5 以上要加:
    # config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    # config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
    #
    # 获取所有的目录结构 方法
    #  Dir[Rails.root.join('app', 'api') + '**/*'].reject { |f| File.file? f }

    #
    config.active_job.queue_adapter = :sidekiq
  end
end


module ValleyRailsGenerator
  class AppBuilder < Rails::AppBuilder
    include ValleyRailsGenerator::Actions

    def readme
      template 'README.md.erb', 'README.md'
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def raise_on_delivery_errors
      replace_in_file 'config/environments/development.rb',
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def raise_on_unpermitted_parameters
      configure_environment 'development',
        'config.action_controller.action_on_unpermitted_parameters = :raise'
    end

    def enable_factory_girl_syntax
      copy_file 'factory_girl_syntax_rspec.rb', 'spec/support/factory_girl.rb'
    end

    def test_factories_first
      copy_file 'factories_spec.rb', 'spec/models/factories_spec.rb'
      append_file 'Rakefile', factories_spec_rake_task
    end

    def configure_smtp
      copy_file 'smtp.rb', 'config/initializers/smtp.rb'

      prepend_file 'config/environments/production.rb',
        "require Rails.root.join('config/initializers/smtp')\n"

      config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
      RUBY

      inject_into_file 'config/environments/production.rb', config,
        :after => 'config.action_mailer.raise_delivery_errors = false'
    end

    def initialize_on_precompile
      inject_into_file 'config/application.rb',
        "\n    config.assets.initialize_on_precompile = false",
        :after => 'config.assets.enabled = true'
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file '_flashes.html.erb', 'app/views/application/_flashes.html.erb'
    end
    # CHANGE?
    def create_shared_javascripts
      copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    end

    def create_application_layout
      template 'valley_layout.html.erb.erb',
        'app/views/layouts/application.html.erb',
        :force => true
    end
    # CHANGE
    def create_common_javascripts
      directory 'javascripts', 'app/assets/javascripts'
    end

    def add_jquery_ui
      inject_into_file 'app/assets/javascripts/application.js',
        "//= require jquery-ui\n", :before => '//= require_tree .'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
        :force => true
    end

    def use_mysql_config_template
      template 'mysql_database.yml.erb', 'config/database.yml',
        :force => true
    end

    def use_sqlite3_config_templatje
      template 'sqlite3_database.yml.erb', 'config/database.yml',
        :force => true
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'Gemfile_clean', 'Gemfile'
    end

    def set_ruby_to_version_being_used
      inject_into_file 'Gemfile', "\n\nruby '#{RUBY_VERSION}'",
        after: /source 'https:\/\/rubygems.org'/
    end

    def enable_database_cleaner
      replace_in_file 'spec/spec_helper.rb',
        'config.use_transactional_fixtures = true',
        'config.use_transactional_fixtures = false'

      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def configure_rspec
      remove_file '.rspec'
      copy_file 'rspec', '.rspec'
      prepend_file 'spec/spec_helper.rb', simplecov_init

      rspec_expect_syntax = <<-RUBY

  config.expect_with :rspec do |c|
    c.syntax = :should
  end
      RUBY

      config = <<-RUBY
    config.generators do |generate|
      generate.test_framework :rspec
      generate.helper false
      generate.stylesheets false
      generate.javascript_engine false
      generate.view_specs false
    end

      RUBY

      inject_into_file 'spec/spec_helper.rb', rspec_expect_syntax,
        :after => 'RSpec.configure do |config|'
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_background_jobs_for_rspec
      copy_file 'background_jobs_rspec.rb', 'spec/support/background_jobs.rb'
      run 'rails g delayed_job:active_record'
    end

    def blacklist_active_record_attributes
      replace_in_file 'config/application.rb',
        'config.active_record.whitelist_attributes = true',
        'config.active_record.whitelist_attributes = false'
    end

    def configure_strong_parameters
      copy_file 'strong_parameters.rb', 'config/initializers/strong_parameters.rb'
    end

    def configure_time_zone
      config = <<-RUBY
    config.active_record.default_timezone = :utc

      RUBY
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_time_formats
      remove_file 'config/locales/en.yml'
      copy_file 'config_locales_en.yml', 'config/locales/en.yml'
    end

    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.local"
      action_mailer_host 'test', 'www.example.com'
      #action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def generate_rspec
      generate 'rspec:install'
    end
    # Stop using this - switch to PhantomJS/Poltergeist
    def configure_capybara_webkit
      append_file 'spec/spec_helper.rb' do
        "\nCapybara.javascript_driver = :webkit"
      end
    end

    def setup_stylesheets
      copy_file 'app/assets/stylesheets/application.css',
        'app/assets/stylesheets/application.css.scss'
      remove_file 'app/assets/stylesheets/application.css'
      concat_file 'import_scss_styles', 'app/assets/stylesheets/application.css.scss'
    end

    def gitignore_files
      concat_file 'valley_gitignore', '.gitignore'
      [
        'app/models',
        'app/assets/images',
        'app/views/pages',
        'db/migrate',
        'log',
        'spec/support',
        'spec/lib',
        'spec/models',
        'spec/views',
        'spec/controllers',
        'spec/helpers',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples',
        'spec/factories',
        'db'
      ].each do |dir|
        empty_directory_with_gitkeep dir
      end
    end

    def init_git
      run 'git init'
    end

    # Figure out what this does.
    def copy_miscellaneous_files
      copy_file 'errors.rb', 'config/initializers/errors.rb'
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset='utf-8' />
  <meta name='ROBOTS' content='NOODP' />
      EOS
      style_tags =<<-EOS
<link href='/assets/application.css' media='all' rel='stylesheet' type='text/css' />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
        replace_in_file "public/#{page}.html", /<style.+>.+<\/style>/mi, style_tags.strip
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Application\.routes\.draw do.*end/m,
        "Application.routes.draw do\nend"
    end

    def add_email_validator
      copy_file 'email_validator.rb', 'app/validators/email_validator.rb'
    end

    def disable_xml_params
      copy_file 'disable_xml_params.rb', 'config/initializers/disable_xml_params.rb'
    end

    def setup_default_rake_task
      append_file 'Rakefile' do
        "task(:default).clear\ntask :default => [:spec]"
      end
    end

    def setup_guard
      copy_file 'Guardfile_example', 'Guardfile'
      copy_file 'spring.rb', 'config/spring.rb'
    end

    private

    def factories_spec_rake_task
      IO.read find_in_source_paths('factories_spec_rake_task.rb')
    end

    def simplecov_init
      IO.read find_in_source_paths('simplecov_init.rb')
    end
  end
end
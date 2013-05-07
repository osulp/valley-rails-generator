require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module ValleyRailsGenerator
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, :type => :string, :aliases => '-d', :default => 'sqlite3',
      :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
      :desc => 'Skip Test::Unit files'

    def finish_template
      invoke :valley_customization
      super
    end

    def valley_customization
      invoke :remove_files_we_dont_need
      invoke :customize_gemfile
      invoke :setup_database
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :setup_staging_environment
      invoke :create_valley_views
      #invoke :create_common_javascripts
      #invoke :add_jquery_ui
      invoke :configure_app
      invoke :setup_stylesheets
      invoke :copy_miscellaneous_files
      invoke :customize_error_pages
      invoke :remove_routes_comment_lines
      invoke :setup_git
      invoke :outro
    end

    def remove_files_we_dont_need
      build :remove_public_index
      build :remove_rails_logo_image
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used
      bundle_command 'install --binstubs=bin/stubs'
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :use_postgres_config_template
      end

      if 'mysql' == options[:database]
        build :use_mysql_config_template
      end

      if 'sqlite3' == options[:database]
        build :use_sqlite3_config_template
      end

      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_delivery_errors
      build :raise_on_unpermitted_parameters
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :enable_factory_girl_syntax
      build :test_factories_first
      build :generate_rspec
      build :configure_rspec
      build :enable_database_cleaner
      build :setup_guard
    end

    def setup_production_environment
      say 'Setting up the production environment'
      build :configure_smtp
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :initialize_on_precompile
    end

    def create_valley_views
      say 'Creating valley views'
      build :create_partials_directory
      build :create_shared_flashes
      build :create_shared_javascripts
      build :create_application_layout
    end

    def configure_app
      say 'Configuring app'
      build :configure_action_mailer
      build :blacklist_active_record_attributes
      build :configure_time_zone
      build :configure_time_formats
      build :disable_xml_params
      build :add_email_validator
      build :setup_default_rake_task
    end

    def setup_stylesheets
      say 'Set up stylesheets'
      build :setup_stylesheets
    end

    def setup_git
      say 'Initializing git'
      invoke :setup_gitignore
      invoke :init_git
    end

    def create_heroku_apps
      if options[:heroku]
        say 'Creating Heroku apps'
        build :create_heroku_apps
      end
    end

    def create_github_repo
      if options[:github]
        say 'Creating Github repo'
        build :create_github_repo, options[:github]
      end
    end

    def setup_gitignore
      build :gitignore_files
    end

    def init_git
      build :init_git
    end

    def copy_libraries
      say 'Copying libraries'
      build :copy_libraries
    end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_miscellaneous_files
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def outro
      say 'Generation Complete'
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    protected

    def get_builder_class
      ValleyRailsGenerator::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
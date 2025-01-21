$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'sortable_by/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'sortable_by'
  s.version     = SortableBy::VERSION
  s.authors     = ['Greg Woods']
  s.email       = ['greg.woods@moserit.com']
  s.homepage    = 'https://github.com/moser-inc/sortable_by'
  s.summary     = 'Simple tool for sorting tables of data in rails'
  s.description = "Adds capabilities to create sortable table headers\
 and connect them to an ActiveRecord query"
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.1'
  s.add_dependency 'rails', '>= 5.0'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rails'
  s.metadata['rubygems_mfa_required'] = 'true'
end

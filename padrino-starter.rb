def source_paths
  root_path = File.expand_path(File.dirname(__FILE__))
  Array(super) + [root_path, File.join(root_path, 'padrino_root')]
end

project renderer: :slim, orm: :none, stylesheet: :none, test: :rspec

# copy over template files for Ruby
# - Gemfile w favourite gems
remove_file 'Gemfile'
copy_file 'padrino_root/Gemfile', 'Gemfile'

# copy dotfiles and any other development config
remove_file '.gitignore'
copy_file 'padrino_root/.gitignore', '.gitignore'
copy_file 'padrino_root/Guardfile', 'Guardfile'

copy_file 'padrino_root/.editorconfig', '.editorconfig'
copy_file 'padrino_root/.rspec', '.rspec'
copy_file 'padrino_root/.rubocop.yml', '.rubocop.yml'
copy_file 'padrino_root/.ruby-version', '.ruby-version'
copy_file 'padrino_root/Procfile', 'Procfile'

# Padrino app files, like config, controllers, views, etc
copy_file 'padrino_root/app/controllers/pages_controller.rb', 'app/controllers/pages_controller.rb'
copy_file 'padrino_root/app/controllers/enquiries_controller.rb', 'app/controllers/enquiries_controller.rb'
copy_file 'padrino_root/app/views/index.html.slim', 'app/views/index.html.slim'
copy_file 'padrino_root/config/unicorn.rb', 'config/unicorn.rb'

# front-end toolchain
# Bower for dependencies
empty_directory 'vendor/bower_components'
create_link './node_modules/bower_components', '../vendor/bower_components'
copy_file 'padrino_root/.bowerrc', '.bowerrc'
copy_file 'padrino_root/bower.json', 'bower.json'

# Gulp for task running, including ES6-compatible Browserify setup
copy_file 'padrino_root/package.json', 'package.json'
copy_file 'padrino_root/gulpfile.js', 'gulpfile.js'

# JS template
copy_file 'padrino_root/app/javascripts/main.js', 'app/javascripts/main.js'
copy_file 'padrino_root/app/javascripts/hero.js', 'app/javascripts/hero.js'

# SMCSS-inspired CSS architecture
copy_file 'padrino_root/app/stylesheets/main.scss', 'app/stylesheets/main.scss'

# CSS folder structure
%w(core components functions pages).each { |path| empty_directory File.join('app/stylesheets/', path) }
copy_file 'padrino_root/app/stylesheets/core/_reset.scss', 'app/stylesheets/core/_reset.scss'

[
  ['app/stylesheets/core/_grid.scss', '// Import and add your grids.'],
  ['app/stylesheets/core/_elements.scss', '// Add base styling to your HTML elements, if needed.'],
  ['app/stylesheets/core/_colors.scss', '// Add SASS variables for your colors.'],
  ['app/stylesheets/core/_dimensions.scss', '// Add SASS variables for your element sizes, converting from pixels if necessary (i.e. rem(24);)'],
  ['app/stylesheets/core/_typography.scss', '// Add SASS variables for your font families, sizes, and weights']
].each { |file_args| create_file(*file_args) }

empty_directory 'app/images/sprites'

# Specs folder structure
['spec/app', 'spec/requests', 'spec/support'].each { |path| empty_directory(path) }

# Run post-generator tasks, like installing dependencies
inside do
  ruby_version = File.read(File.join(File.dirname(__FILE__), 'padrino_root/.ruby-version')).strip
  run "~/.rbenv/versions/#{ruby_version}/bin/bundle install"
  run 'npm install'
  run 'node_modules/.bin/bower install'

  # do an initial build of template JS
  run './node_modules/.bin/gulp browserify'
end

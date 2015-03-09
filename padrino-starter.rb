def source_paths
  root_path = File.expand_path(File.dirname(__FILE__))
  Array(super) + [root_path, File.join(root_path, 'padrino_root')]
end

# for landing page

# create Padrino project with
# - Slim templates
# - tiny skeleton
# - no ORM
# - SCSS stylesheets
# 	- no Compass for now, maybe later
# - Rspec tests
project tiny: true, renderer: :slim, orm: :none, stylesheet: :scss, test: :rspec

# copy over template files for Ruby
# - Gemfile w favourite gems
remove_file 'Gemfile'
copy_file 'padrino_root/Gemfile', 'Gemfile'

# copy dotfiles and any other development config
copy_file 'padrino_root/.editorconfig', '.editorconfig'
copy_file 'padrino_root/.rspec', '.rspec'
copy_file 'padrino_root/.rubocop.yml', '.rubocop.yml'
copy_file 'padrino_root/.ruby-version', '.ruby-version'
copy_file 'padrino_root/Procfile', 'Procfile'


# - app/controllers.rb
# 	- set up default w active index route
# 	- set up commented-out default for contact form backend
remove_file 'app/controllers.rb'
copy_file 'padrino_root/app/controllers.rb', 'app/controllers.rb'
copy_file 'padrino_root/app/views/index.html.slim', 'app/views/index.html.slim'

# Set up front-end toolchain
# - front-end deps
# 	- (YES) probably Bower
# 	- (NO)investigate whether NPM is do-able yet
#     - close, but installing into /node_modules is sub-optimal
empty_directory 'vendor/bower_components'

# Create symlink to allow non-relative Node module imports for bower components
create_link './node_modules/bower_components', '../vendor/bower_components'

copy_file 'padrino_root/.bowerrc', '.bowerrc'
copy_file 'padrino_root/bower.json', 'bower.json'
copy_file 'padrino_root/package.json', 'package.json'
copy_file 'padrino_root/gulpfile.js', 'gulpfile.js'

# - sprite generator?

# base JS
copy_file 'padrino_root/app/javascripts/main.js', 'app/javascripts/main.js'

# possibles / optionals
# - ditch Padrino-based SASS pre-processing, and switch to all Gulp

# Create directories for modular SMCSS-inspired stylesheets
remove_file 'lib/scss_initializer.rb'
copy_file 'padrino_root/lib/scss_initializer.rb', 'lib/scss_initializer.rb'
copy_file 'padrino_root/app/stylesheets/main.scss', 'app/stylesheets/main.scss'
%w(core components functions pages).each { |path| empty_directory File.join('app/stylesheets/', path) }

copy_file 'padrino_root/app/stylesheets/core/_reset.scss', 'app/stylesheets/core/_reset.scss'

[
  ['app/stylesheets/core/_grid.scss', '// Import and add your grids.'],
  ['app/stylesheets/core/_elements.scss', '// Add base styling to your HTML elements, if needed.'],
  ['app/stylesheets/core/_colors.scss', '// Add SASS variables for your colors.'],
  ['app/stylesheets/core/_dimensions.scss', '// Add SASS variables for your element sizes, converting from pixels if necessary (i.e. rem(24);)'],
  ['app/stylesheets/core/_typography.scss', '// Add SASS variables for your font families, sizes, and weights']
].each { |file_args| create_file(*file_args) }

# Install dependencies from Rubygems, NPM, and Bower
inside do
  ruby_version = File.read(File.join(File.dirname(__FILE__), 'padrino_root/.ruby-version')).strip
  run "~/.rbenv/versions/#{ruby_version}/bin/bundle install"
  run 'npm install'
  run 'node_modules/.bin/bower install'

  # do an initial build of template JS
  run './node_modules/.bin/gulp browserify'
end

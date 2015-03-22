var gulp = require('gulp');

var browserify = require('browserify');
var concatCss = require('gulp-concat-css');
var cssSprite = require('css-sprite').stream;
var gulpIf = require('gulp-if');
var gutil = require('gulp-util');
var path = require('path');
var sass = require('gulp-ruby-sass');
var source = require('vinyl-source-stream');
var watchify = require('watchify');

var buildPaths = {
  jsSourcePath: './app/javascripts/main.js',
  jsDestDir: './public/javascripts',
  jsDestFile: 'main.js',
  sassSourcePath: './app/stylesheets/main.scss',
  sassDestDir: './public/stylesheets'
};

// set up watchify
var bundler = watchify(browserify(buildPaths.jsSourcePath, watchify.args));

bundler.on('update', bundle);
bundler.on('log', gutil.log);

function bundle() {
  return bundler.bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source(buildPaths.jsDestFile))
    .pipe(gulp.dest(buildPaths.jsDestDir));
}

gulp.task('watchify', bundle);

gulp.task('browserify', function() {
  return browserify(buildPaths.jsSourcePath)
    .bundle()
    .pipe(source(buildPaths.jsDestFile))
    .pipe(gulp.dest(buildPaths.jsDestDir));
});

gulp.task('images', function() {
  return gulp.src('./app/images/sprites/*.png')
    .pipe(
      cssSprite({
        name: 'sprites',
        style: '_sprites.scss',
        cssPath: './images',
        processor: 'scss',
        cachebuster: true,
        base64: true
      }))
    .pipe(
      gulpIf(
        '*.png',
        gulp.dest('./public/images/'),
        gulp.dest('./app/stylesheets/functions/')
      )
    );
});

gulp.task('sass', function() {
  return sass(
    buildPaths.sassSourcePath, {
      bundleExec: true,
      loadPath: ['.', 'vendor/bower_components/'],
      require: ['bourbon']
    })
    .on('error', function (err) { console.log(err.message); })
    .pipe(gulp.dest(buildPaths.sassDestDir));
});

gulp.task('vendor', function() {
  gulp.src([]).pipe(concatCss('stylesheets/vendor.css'))
    .pipe(gulp.dest('public/'))
});

gulp.task('watch', ['watchify', 'sass', 'images'], function() {
  var sassWatcher = gulp.watch('./app/stylesheets/**/*.scss', ['sass']);
  var cssWatcher = gulp.watch('./vendor/bower_components/**/*.css', ['vendor']);
  var imageWatcher = gulp.watch('./app/images/**/*', ['images']);
});

var path = require('path');
var gulp = require('gulp');
var gutil = require('gulp-util');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var browserify = require('browserify');

var buildPaths = {
  sourcePath: './app/javascripts/main.js',
  destDir: './public/javascripts',
  destFile: 'main.js'
};

// set up watchify
var bundler = watchify(browserify(buildPaths.sourcePath, watchify.args));

bundler.transform('babelify');
bundler.on('update', bundle);
bundler.on('log', gutil.log);

function bundle() {
  return bundler.bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source(buildPaths.destFile))
    .pipe(gulp.dest(buildPaths.destDir));
}

gulp.task('watchify', bundle); // so you can run `gulp js` to build the file

gulp.task('browserify', function() {
  return browserify(buildPaths.sourcePath)
    .bundle()
    .pipe(source(buildPaths.destFile))
    .pipe(gulp.dest(buildPaths.destDir));
});

gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'

assets = [
  'assets/manifest.json'
  'libs/mousetrap.min.js' # TODO: fetch this from https://raw.githubusercontent.com/wildeyes/mousetrap/master/mousetrap.min.js
  'libs/zepto.min.js'
]
sources = ['src/*','assets/database.coffee']

gulp.task 'build', ['copy:libs','coffee']

gulp.task 'default', ->
  #gulp.start('build')
  gulp.watch './*', 'build'

gulp.task 'publish', -> "hello"

gulp.task 'copy:libs', ->
  gulp.src assets
    .pipe gulp.dest 'build'

gulp.task 'coffee', ->
  gulp.src sources
    .pipe coffee(bare: true).on 'error', gutil.log
    .pipe gulp.dest 'build'
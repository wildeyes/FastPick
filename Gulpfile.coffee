gulp = require 'gulp'
coffee = require 'gulp-coffee'

libs = [
  'libs/common.js'
  'libs/mousetrap.min.js'
  'libs/zepto.min.js'
  'assets/manifest.json'
]
sources = ['assets/database.coffee']

gulp.task 'build', ['libs','coffee']

gulp.task 'default', ->
  gulp.start('build')
  gulp.watch(libs, ['libs'])
  gulp.watch(sources, ['coffee'])

gulp.task 'libs', ->
  gulp.src libs
    .pipe gulp.dest 'build'
()
gulp.task 'coffee', ->
  cs = coffee bare: true
  gulp.src sources
    .pipe(coffee(bare: true).on 'error', (err) -> console.error err)
    .pipe gulp.dest 'build'

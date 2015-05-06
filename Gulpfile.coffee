gulp = require 'gulp'
coffee = require 'gulp-coffee'

assets = [
  'libs/common.js'
  'assets/manifest.json'
  'libs/mousetrap.min.js'
  'libs/zepto.min.js'
]
sources = ['src/*','assets/database.coffee']

gulp.task 'build', ['libs','coffee']

gulp.task 'default', ->
  gulp.start('build')
  gulp.watch(sources, ['coffee'])

gulp.task 'libs', ->
  gulp.src assets
    .pipe gulp.dest 'build'

gulp.task 'coffee', ->
  cs = coffee bare: true
  gulp.src sources
    .pipe(coffee(bare: true).on 'error', (err) -> console.error err)
    .pipe gulp.dest 'build'

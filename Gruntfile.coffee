module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)
  path =
    build: 'build'

  grunt.registerTask 'init', ['mkdir:init','manifest:dev','copy:init','coffee:script','coffee:eventpage']
  grunt.registerTask 'default', "watch"# ['concurrent:dev']
  grunt.registerTask 'package', "", ['prepackage','copy:package','uglifyjs']

  grunt.initConfig
    pkg      : grunt.file.readJSON 'package.json'
    manifest : grunt.file.readJSON 'assets/manifest.json'
    coffee:
      options:
        bare: true
        join: true
      script:
        files: {'#{path.build}/script.js': 'src/script.coffee'}
      database:
        files: {'#{path.build}/database.js': 'assets/database.coffee'}
      eventpage:
        files: {'#{path.build}/eventpage.js': 'src/eventpage_tabbing.coffee'}
    watch:
      script:
        files: ['src/script.coffee']
        tasks: ['coffee:script']
      database:
        files: ['src/database.coffee']
        tasks: ['coffee:database']
      eventpage:
        files: ['src/eventpage.coffee']
        tasks: ['coffee:eventpage']
    copy:
      init:
        expand: true
        src: ['bower_components/jquery/jquery.min.js', 'bower_components/mousetrap/mousetrap.min.js'] # Manifest is copied in it's own task
        dest: '#{path.build}/'
        flatten: true
      packge:
        expand: true
        src: ['assets/manifest.json'] # Manifest is copied in it's own task
        dest: '#{path.build}/'
        flatten: true
    bower: # Doesn't work yet
      install:
        options:
          targetDir: './lib',
          layout: 'byType',
          install: true,
          verbose: false,
          cleanTargetDir: false,
          cleanBowerDir: false,
          bowerOptions: {}
    crx:
      compile:
        "src"        : "#{path.build}/"
        "dest"       : "<%= crxfile %>"
        "baseURL"    : "https://github.com/wildeyes/Pi6"
        "exclude"    : [ ".git" ]
        "privateKey" : "../pems/Pi6.pem"
        "maxBuffer"  : 3000 * 1024
    crxfile:"package/<%= pkg.name %>.crx"

  #http://stackoverflow.com/questions/17052301/updating-file-references-in-a-json-file-via-a-grunt-task
  grunt.registerTask 'prepackage', ->
    # require 'shelljs/global'
    # mkdir './tmp/cstmp'
    path.build = 'tmp'
  grunt.registerTask 'mkdir:init', ->
    require 'shelljs/global'
    mkdir './build'
  grunt.registerTask 'manifest:dev', 'Update manifest with development values', ->
    fs = require 'fs'

    orig = require  './assets/manifest.json'
    newvalues = require './assets/manifest-dev.json'

    for key, value of newvalues
      orig[key] = value

    fs.writeFileSync './build/manifest.json', JSON.stringify orig

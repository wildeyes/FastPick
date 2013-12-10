module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.registerTask 'init', ['mkdir:init','manifest:dev','copy:init','coffee:script','coffee:eventpage']
  grunt.registerTask 'default', "watch"# ['concurrent:dev']
  grunt.registerTask 'publish', "", ['mkdir:publish','copy:manifest','uglify','compress','clean']


  grunt.initConfig
    pkg      : grunt.file.readJSON 'package.json'
    manifest : grunt.file.readJSON 'assets/manifest.json'
    coffee:
      options:
        bare: true
        join: true
      script:
        files: {'build/script.js': 'src/script.coffee'}
      database:
        files: {'build/database.js': 'assets/database.coffee'}
      eventpage:
        files: {'build/eventpage.js': 'src/eventpage_tabbing.coffee'}
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
        flatten: true
        src: ['bower_components/jquery/jquery.min.js', 'bower_components/mousetrap/mousetrap.min.js']
        dest: 'build/'
      manifest:
        expand: true
        src: ['assets/manifest.json']
        dest: 'build'
        flatten: true
    uglify:[
      dest: "tmp/main.js"
      src: ['build/jquery.min.js','build/mousetrap.min.js','build/script.js','build/database.js']
    ]
    compress:
      package:
        options:
          mode:'zip'
          archive: "builds/<%=manifest.name%>-<%= manifest.version %>.zip"
        files: [
          expand:true
          src:'tmp/**'
        ]
  grunt.registerTask 'mkdir:init', ->
    require 'shelljs/global'
    mkdir './build'

  grunt.registerTask 'mkdir:publish', ->
    require 'shelljs/global'
    mkdir 'tmp'
    grunt.config 'uglify.dest', 'tmp/main.js'
    grunt.config 'copy.manifest.dest', 'tmp/'
  grunt.registerTask 'clean', ->
    require 'shelljs/global'
    # rm '-r', 'tmp'

  #http://stackoverflow.com/questions/17052301/updating-file-references-in-a-json-file-via-a-grunt-task
  grunt.registerTask 'manifest:dev', 'Update manifest with development values', ->
    fs = require 'fs'

    orig = require  './assets/manifest.json'
    newvalues = require './assets/manifest-dev.json'

    for key, value of newvalues
      orig[key] = value

    fs.writeFileSync './build/manifest.json', JSON.stringify orig

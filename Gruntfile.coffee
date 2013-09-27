shjs = require 'shelljs'

module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        manifest: grunt.file.readJSON('manifest.json'),
        coffee:
            main:
                files:
                    'build/script.js': 'src/script.coffee'
            dev:
                options:
                    join: true
                files:
                    'build/eventpage.js': ['src/eventpage_tabbing.coffee','src/eventpage_update_dev.coffee']
            prod:
                options:
                    join: true
                files:
                    'build/eventpage.js': ['src/eventpage_tabbing.coffee','src/eventpage_update_prod.coffee']
        watch:
            main:
                files: ['src/script.coffee'],
                tasks: ['coffee:main','reload']
            eventpage:
                files: ['src/eventpage_tabbing.coffee', 'src/eventpage_update_dev.coffee'],
                tasks: ['coffee:dev','reload']
        crx:
            compile:
                "src": "build/",
                "dest": "data/<%= pkg.name %>-<%= manifest.version %>.crx",
                "baseURL": "https://github.com/wildeyes/Pi6",
                "exclude": [ ".git" ],
                "privateKey": "../pems/Pi6.pem",
                "maxBuffer": 3000 * 1024

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks('grunt-crx')

    grunt.registerTask 'reload', 'Reload Browser=>{current page + (previously opened) chrome://extensions page}', ->
        path = '$HOME/bin/chromix/script/chromix.js' # TODO: Use a project relative path
        shjs.exec("node #{path} with 'chrome://extensions' reload")
        shjs.exec("node #{path} reload")

    grunt.registerTask 'rocket', 'Compiles the frameworks data into JSON', ->
        path = '$HOME/code/Pi6/flyrocket.js'  # TODO: Use a project relative path
        shjs.exec("node #{path}")

    grunt.registerTask 'test', ['watch:dev']

    grunt.registerTask('prepublish', ['rocket','coffee:main','coffee:prod','crx']);
    # grunt.registerTask('publish', ['jshint', 'qunit', 'concat', 'uglify']);

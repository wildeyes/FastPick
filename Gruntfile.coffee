shjs = require 'shelljs'

module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        manifest: grunt.file.readJSON('manifest.json'),
        coffee:
            script:
                options:
                    bare: true
                    join: true
                files:
                    'build/script.js': ['src/rocket.coffee','src/script.coffee']
            eventpage:
                options:
                    bare: true
                files:
                    'build/eventpage.js': ['src/eventpage_tabbing.coffee']
        watch:
            devmain:
                files: ['src/rocket.coffee','src/script.coffee'],
                tasks: ['coffee:script','reload']
            deveventpage:
                files: ['src/eventpage_tabbing.coffee', 'src/eventpage_update_dev.coffee'],
                tasks: ['coffee:eventpage','reload']
        concurrent:
            dev:
                options:
                    logConcurrentOutput: true
                tasks: ['watch:devmain','watch:deveventpage']
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
    grunt.loadNpmTasks 'grunt-crx'
    grunt.loadNpmTasks 'grunt-concurrent'

    grunt.registerTask 'reload', 'Reload Browser=>{current page + (previously opened) chrome://extensions page}', ->
        server    = 'node $HOME/bin/chromix/script/server.jsd'
        chromix = 'node $HOME/bin/chromix/script/chromix.js'
        shjs.exec "#{chromix} with 'chrome://extensions' reload"
        shjs.exec "#{chromix} reload"
    grunt.registerTask 'testcrx', 'Load testing CRX', ->
        pkg = grunt.config('pkg')
        manifest = grunt.config('manifest')
        crx = "#{pkg.name}-#{manifest.version}.crx"
        shjs.exec "chromium --load-component-extension data/#{crx}"
    grunt.registerTask 'dev', ['concurrent:dev']
    grunt.registerTask('prepublish', ['src/rocket','coffee:main','coffee:onlyprod','crx']);

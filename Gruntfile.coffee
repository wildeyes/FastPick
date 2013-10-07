shjs = require 'shelljs'

module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        manifest: grunt.file.readJSON('manifest.json'),
        coffee:
            main:
                files:
                    'build/script.js': 'src/script.coffee'
            onlydev:
                options:
                    join: true
                files:
                    'build/eventpage.js': ['src/eventpage_tabbing.coffee','src/eventpage_update_dev.coffee']
            onlyprod:
                options:
                    join: true
                files:
                    'build/eventpage.js': ['src/eventpage_tabbing.coffee','src/eventpage_update_prod.coffee']
        watch:
            devmain:
                files: ['src/script.coffee'],
                tasks: ['coffee:main','reload']
            deveventpage:
                files: ['src/eventpage_tabbing.coffee', 'src/eventpage_update_dev.coffee'],
                tasks: ['coffee:onlydev','reload']
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
    grunt.loadNpmTasks('grunt-crx')
    grunt.loadNpmTasks('grunt-concurrent')

    grunt.registerTask 'reload', 'Reload Browser=>{current page + (previously opened) chrome://extensions page}', ->
        path = '$HOME/bin/chromix/script/chromix.js' # TODO: Use a project relative path
        shjs.exec("node #{path} with 'chrome://extensions' reload") # TODO What's faster: This or --load-extension switch?
        shjs.exec("node #{path} reload")

    grunt.registerTask 'testcrx', 'Load testing CRX', ->
        pkg = grunt.config('pkg')
        manifest = grunt.config('manifest')
        crx = "#{pkg.name}-#{manifest.version}.crx"
        shjs.exec("chromium --load-component-extension data/#{crx}")

    grunt.registerTask 'rocket', 'Compiles the frameworks data into JSON', ->
        path = '$HOME/code/Pi6/'  # TODO: Use a project relative path
        shjs.exec("node #{path}/flyrocket.js #{path}/data/rocket.min.json")

    grunt.registerTask 'test', ['concurrent:dev']
    grunt.registerTask('prepublish', ['rocket','coffee:main','coffee:onlyprod','crx']);

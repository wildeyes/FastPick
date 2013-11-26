require 'shelljs/global'

module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        manifest: grunt.file.readJSON('assets/manifest.json'),
        coffee:
            script:
                options:
                    bare: true
                    join: true
                files:
                    'build/script.js': ['assets/database.coffee','src/script.coffee']
            eventpage:
                options:
                    bare: true
                files:
                    'build/eventpage.js': ['src/eventpage_tabbing.coffee']
        watch:
            devmain:
                files: ['assets/database.coffee','src/script.coffee'],
                tasks: ['coffee:script','reload']
            # the event page raaaaarely changes.
            # deveventpage:
            #     files: ['src/eventpage_tabbing.coffee', 'src/eventpage_update_dev.coffee'],
            #     tasks: ['coffee:eventpage','reload']
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

    grunt.registerTask 'init', ['init-dev','coffee:script','coffee:eventpage']
    grunt.registerTask 'init-dev', 'Run init script', ->
        mkdir '-p', 'build'
        exec 'ln assets/{jquery,mousetrap}.js build/'
        exec 'ln assets/manifest.json build/'

    grunt.registerTask 'default', 'Setup everything to develop', ['server','dev']
    grunt.registerTask 'dev', ['concurrent:dev']
    grunt.registerTask 'server', 'Setup Chromix Server', ->
        exec 'terminator -e "node $HOME/bin/chromix/script/server.js" &', async:on
    grunt.registerTask 'reload', 'Reload Browser=>{current page + (previously opened) chrome://page extensions}', ->
        server    = 'node $HOME/bin/chromix/script/server.js'
        chromix = 'node $HOME/bin/chromix/script/chromix.js'
        exec "#{chromix} with 'chrome://extensions' reload"
        exec "#{chromix} reload"
    grunt.registerTask 'testcrx', 'Load testing CRX', ->
        pkg = grunt.config('pkg')
        manifest = grunt.config('manifest')
        crx = "#{pkg.name}-#{manifest.version}.crx"
        exec "chromium --load-component-extension data/#{crx}"

    grunt.registerTask('prepublish', ['src/rocket','coffee:main','coffee:onlyprod','crx']);
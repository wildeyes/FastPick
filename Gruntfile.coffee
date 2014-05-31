module.exports = (grunt) ->
  require("load-grunt-tasks")(grunt)
  require("time-grunt")(grunt)

  grunt.registerTask "build", ["copy:init","coffee"]
  grunt.registerTask "default", "watch"
  grunt.registerTask "publish", "", ["build","compress"] #,"clean"]

  grunt.initConfig
    manifest : grunt.file.readJSON "assets/manifest.json"
    coffee:
      options:
        bare: true
        join: true
      script:
        files: {"build/script.js": "src/script.coffee"}
      database:
        files: {"build/database.js": "assets/database.coffee"}
      eventpage:
        files: {"build/eventpage.js": "src/eventpage_tabbing.coffee"}
    watch:
      script:
        files: ["src/script.coffee"]
        tasks: ["coffee:script"]
      database:
        files: ["src/database.coffee"]
        tasks: ["coffee:database"]
      eventpage:
        files: ["src/eventpage.coffee"]
        tasks: ["coffee:eventpage"]
    copy:
      init:
        expand: true
        flatten: true
        src: [
           "assets/manifest.json"
           "libs/mousetrap.min.js" # TODO: fetch this from https://raw.githubusercontent.com/wildeyes/mousetrap/master/mousetrap.min.js
           "libs/zepto.min.js"
        ]
        dest: "build"
    compress:
      package:
        options:
          mode:"zip"
          archive: "builds/<%=manifest.name%>-<%= manifest.version %>.zip"
        files: [
          expand:true
          src:"tmp/**"
        ]

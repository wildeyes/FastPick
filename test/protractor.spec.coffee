b = './../build/'
db = require("{#build}/database.json")

describe 'Fast Pick Extension', ->
    describe 'when visiting a regular site', ->
        browser.get 'http://google.com'

        expect

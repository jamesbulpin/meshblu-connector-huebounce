http = require 'http'
debug = require('debug')('meshblu-connector-huebounce:PushButton')

class PushButton
  constructor: ({@connector}) ->
    throw new Error 'PushButton requires connector' unless @connector?
    
  do: ({}, callback) =>

    debug "Inject button push"
    @connector.bounce.injectButton()
  
    #metadata =
    #  code: 200
    #  status: http.STATUS_CODES[200]
    #data = {}
    #callback null, {metadata, data}
    callback null, null
    
  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = PushButton

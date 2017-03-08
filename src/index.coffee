{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-huebounce:index')
BounceManager   = require './bounce-manager'
_               = require 'lodash'

class Connector extends EventEmitter
  constructor: ->
    @bounce = new BounceManager
    @bounce.on 'update', (data) =>
      @emit 'update', data
    @bounce.on 'error', (error) =>
      @emit 'error', error
    @bounce.on 'message', (message) =>
      @emit 'message', message

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    @bounce.close callback

  onConfig: (device={}, callback=->) =>
    { options } = device
    debug 'on config', options
    @bounce.close (error) =>
      return callback error if error?
      @bounce.connect {options}, (error) =>
        return callback error if error?
        @connected = true
        callback()

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector

_                = require 'lodash'
{EventEmitter}   = require 'events'
debug            = require('debug')('meshblu-connector-huebounce:bounce-manager')
MeshbluSocketIO  = require 'meshblu'
_                = require 'lodash'

class BounceManager extends EventEmitter
  connect: ({ @options }, callback) =>
    @_emit = _.throttle @emit, 500, {leading: true, trailing: false}
    @options ?= {}
    
    resolveSrv = true
    domain = @options.buttondomain
    uuid = @options.buttonuuid
    token = @options.buttontoken
    @mb_button = new MeshbluSocketIO({uuid, token, domain, resolveSrv})
    @mb_button.on 'ready', () =>
      debug 'Hue Tap button connector ready'
    @mb_button.on 'config', (device) =>
      @mb_button_device = device
    @mb_button.connect()

    resolveSrv = true
    domain = @options.lightdomain
    uuid = @options.lightuuid
    token = @options.lighttoken
    @mb_light = new MeshbluSocketIO({uuid, token, domain, resolveSrv})
    @mb_light.on 'ready', () =>
      debug 'Hue light connector ready'
    @mb_light.on 'config', (device) =>
      @_handleLightOnConfig device
    @mb_light.connect()
    
    callback()

  close: (callback) =>
    @mb_button_device = null
    if @mb_button?
      @mb_button.close () =>
        debug 'Closed Hue button meshblu connection'
      @mb_button = null

    if @mb_light?
      @mb_light.close () =>
        debug 'Closed Hue light meshblu connection'
      @mb_light = null
    callback()

  injectButton: =>
    if @mb_button? and @mb_button_device?
      state = 
        'buttonevent': 34
        'lastupdated': (new Date).toISOString()
      data = 
        action: 'click'
        button: '1'
        state: state
        device: @mb_button_device
      debug 'Sending Hue button message'
      @mb_button.message {devices: [ '*' ], data}

  _handleLightOnConfig: (device) =>
    if device.desiredState? and device.desiredState.on? and device.desiredState.color?
      data =
        on: device.desiredState.on
        color: device.desiredState.color
      @emit 'message', {devices: ['*'], data}
      
module.exports = BounceManager

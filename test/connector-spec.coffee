Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    @sut = new Connector
    {@bounce} = @sut
    @bounce.connect = sinon.stub().yields null
    @sut.start {}, done

  afterEach (done) ->
    @sut.close done

  it 'should call connect', ->
    expect(@bounce.connect).to.have.been.called

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->onConfig', ->
    describe 'when called with a config', ->
      it 'should not throw an error', ->
        expect(=> @sut.onConfig { type: 'hello' }).to.not.throw(Error)

'use strict'

Utils = {}
Utils.map = (value, inputMin, inputMax, outputMin, outputMax, clamp) ->
  outValue = ((value - inputMin) / (inputMax - inputMin)) * (outputMax - outputMin) + outputMin
  if clamp
    if outputMax > outputMin
      if outValue > outputMax
        outValue = outputMax
      else outValue = outputMin  if outValue < outputMin
    else
      if outValue < outputMax
        outValue = outputMax
      else outValue = outputMin  if outValue > outputMin
  outValue

Utils.mapNorm = (value, start, end) ->
  Utils.map value, 0, 1, start, end
  
class PaperCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "$famous"]
  
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @famous) ->
    super @scope
    Transitionable = @famous["famous/transitions/Transitionable"]
    GenericSync = @famous["famous/inputs/GenericSync"]
    MouseSync = @famous["famous/inputs/MouseSync"]
    TouchSync = @famous["famous/inputs/TouchSync"]
    RotateSync = @famous["famous/inputs/RotateSync"]
    PinchSync = @famous["famous/inputs/PinchSync"]
    Surface = @famous["famous/core/Surface"]
    Engine = @famous["famous/core/Engine"]
    Transform = @famous["famous/core/Transform"]
    EventHandler = @famous["famous/core/EventHandler"]
    
    GenericSync.register 
      mouse : MouseSync
      touch : TouchSync
    
    @scope.heroPipe = new EventHandler();
    @scope.options = 
      heroScrollView:
        paginated: true
        direction: 0
        speedLimit: 5
        margin: 10000
      paperListScrollView:
        paginated: true
        direction: 0
        speedLimit: 5
        margin: 10000
              
    @scope.paperPipe = new EventHandler();
    @scope.paperListPipe = @_paperListPipe = new EventHandler();
    @scope.innerPaperListPipe = @_innerPaperListPipe = new EventHandler();
    @scope.innerPaperListPipe.pipe @scope.paperListPipe
    
    applySync = new GenericSync(['mouse', 'touch'])
    # @scope.paperListPipe.pipe applySync
    @scope.heroPipe.pipe @scope.paperPipe
    @scope.paperPipe.pipe applySync
    @scope.paperpos = new Transitionable([0, 0])
    applySync.on "start", (e) =>
      @applyStartDrag = true
      # console.log "mousedown"
      # @menuStartX = e.clientX
      pos = @scope.paperpos.get()
      @applyStartY = -pos[1]+e.clientY
      if pos[1] < 0
        #in open state
        @applyDirection = "close"
      else
        @applyDirection = "open"
        #in close state
    endApplySync = (e) =>
      if not @applyStartDrag
        return
      @applyStartDrag = false
      if @applyDirection == "open" 
        if Math.abs(e.clientY-@applyStartY) > 25
          @scope.paperpos.set [0,-(568-40)],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false
        else
          @scope.paperpos.set [0,0],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false
      else
        if e.clientY-@applyStartY > -(568-40)+25
          @scope.paperpos.set [0,0],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false          
        else
          @scope.paperpos.set [0,-(568-40)],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false
  
    applySync.on "end", endApplySync
    applySync.on "update", (e) =>
      if @applyStartDrag
        @applyDragging = true
        @scope.paperpos.set [0, e.clientY-@applyStartY]
    @scope.paperPipe.on "mouseleave", endApplySync
    
    pullSync = new GenericSync(['mouse', 'touch'])
    @initScale = 0.7
    @scope.paperScale = new Transitionable([@initScale, @initScale ])
    @scope.paperListPos = new Transitionable([0,0])
    @scope.paperListPipe.pipe pullSync
    pullSync.on "start", (e) =>
    endPullSync = (e) =>
      paperScale = @scope.paperScale.get()
      if Math.abs(paperScale[1] - 1.0) < Math.abs(paperScale[1] - @initScale)
        @scope.paperScale.set [1,1],{duration : 300,curve : 'inSine'},=>
          @paperDragging = false
          @timeout =>
            @scope.innerPaperListPipe = undefined
      else
        @scope.paperScale.set [@initScale,@initScale],{duration : 300,curve : 'inSine'},=>
          @paperDragging = false
          @timeout =>
            @scope.innerPaperListPipe = @_innerPaperListPipe
          
    pullSync.on "end", endPullSync
    pullSync.on "update", (e) =>
      paperScale = @scope.paperScale.get()
      paperPos = @scope.paperListPos.get()
      console.log paperPos[1]
      # if paperScale[1] < 1
      scale = 1-e.delta[1]/568
      @scope.paperScale.set [paperScale[1]*scale,paperScale[1]*scale]
      # else
      #   if paperPos[1] <= 0
      #     @scope.paperListPos.set [0,paperPos[1]+e.delta[1]]
      #   else
      #     @scope.paperListPos.set [0,0]
      #     scale = 1-e.delta[1]/568
      #     @scope.paperScale.set [paperScale[1]*scale,paperScale[1]*scale]
        
    @scope.paperListPipe.on "mouseleave", endPullSync
  scrollYScale: =>
    return (@scope.paperScale.get()[0]-@initScale)/(1-@initScale)
angular.module('simplecareersApp').controller('PaperCtrl', PaperCtrl)

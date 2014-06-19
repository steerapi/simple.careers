'use strict'


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
    @scope.paperListPipe = new EventHandler();


    applySync = new GenericSync(['mouse', 'touch'])
    # @scope.paperListPipe.pipe applySync
    @scope.heroPipe.pipe @scope.paperPipe
    @scope.paperPipe.pipe applySync
    @scope.paperpos = new Transitionable([0, 0])
    applySync.on "start", (e) =>
      console.log "start"
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
          @scope.paperpos.set [0,-490+15],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false
        else
          @scope.paperpos.set [0,0],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false
      else
        if e.clientY-@applyStartY > -490+25
          @scope.paperpos.set [0,0],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false          
        else
          @scope.paperpos.set [0,-490+15],{duration : 300,curve : 'inSine'},=>
            @applyDragging = false
  
    applySync.on "end", endApplySync
    applySync.on "update", (e) =>
      if @applyStartDrag
        @applyDragging = true
        @scope.paperpos.set [0, e.clientY-@applyStartY]
    @scope.paperPipe.on "mouseleave", endApplySync
    
    pullSync = new GenericSync(['mouse', 'touch'])
    @scope.paperScale = new Transitionable([0.5, 0.5])
    @scope.paperListPipe.pipe pullSync
    pullSync.on "start", (e) =>
      @paperStartDrag = true
      # console.log "mousedown"
      # @menuStartX = e.clientX
      pos = @scope.paperScale.get()
      @paperStartY = -pos[1]+e.clientY
      if pos[1] < 0
        #in open state
        @paperDirection = "close"
      else
        @paperDirection = "open"
        #in close state
    endPullSync = (e) =>
      if not @paperStartDrag
        return
      @paperStartDrag = false
      @scope.paperScale.set [1,1],{duration : 300,curve : 'inSine'},=>
        @paperDragging = false
  
    pullSync.on "end", endPullSync
    pullSync.on "update", (e) =>
      if @paperStartDrag
        @paperDragging = true
        paperScale = @scope.paperScale.get()
        @scope.paperScale.set [paperScale[0]*1.1,paperScale[1]*1.1]
    @scope.paperListPipe.on "mouseleave", endPullSync
    
angular.module('simplecareersApp').controller('PaperCtrl', PaperCtrl)

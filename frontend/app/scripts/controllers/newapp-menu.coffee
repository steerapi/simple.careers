'use strict'

class NewAppMenuCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "$famous"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @famous) ->
    Transitionable = @famous["famous/transitions/Transitionable"]
    GenericSync = @famous["famous/inputs/GenericSync"]
    RotateSync = @famous["famous/inputs/RotateSync"]
    PinchSync = @famous["famous/inputs/PinchSync"]
    Surface = @famous["famous/core/Surface"]
    Engine = @famous["famous/core/Engine"]
    Transform = @famous["famous/core/Transform"]
    EventHandler = @famous["famous/core/EventHandler"]
    
    # tran = new Transitionable(0)
    # 
    # @scope.sync = new GenericSync(->
    #   tran.get()
    # ,
    #   direction: GenericSync.DIRECTION_Y
    # )
    # 
    # SCROLL_SENSITIVITY = 1200 #inverse
    # @scope.sync.on "update", (data) ->
    #   newVal = Math.max(0, Math.min(1, data.delta / SCROLL_SENSITIVITY + tran.get()))
    #   tran.set newVal
    #   return
    # 
    # @scope.eventHandler = new EventHandler()
    # @scope.eventHandler.pipe(@scope.sync);
    # Engine.pipe(@scope.eventHandler)
    
    @scope.options = 
      menuItemGridLayout:
        dimensions: [1, 3]
    @scope.logo =
      translate: [100,100]
      origin: [110,67]
      size: [100,39]
      
    @scope.menus = ["My Profile","Help","Settings"]
      
    @timeout =>
      @scope.$broadcast('startEvent')
    , 1000
    
angular.module('simplecareersApp').controller('NewAppMenuCtrl', NewAppMenuCtrl)

'use strict'

class NewAppCtrl extends Ctrl
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
    
    @scope.enginePipe = new EventHandler();
    Engine.pipe(@scope.enginePipe);
    
    @scope.options = 
      menuItemGridLayout:
        dimensions: [1, 3]
      mainScrollView:
        paginated: true
        direction: 1
        speedLimit: 5
        margin: 10000
      applyList:
        direction: 1
      applyMenuList:
        direction: 0

    # @timeout =>
    #   @scope.$broadcast('startEvent')
    # , 1000
        
    @scope.applymenus = ["LIKE","APPLIED","APPROVED"]
    
    @scope.menus = ["My Profile","Help","Settings"]
    
    # @scope.scrollYPosition = =>
    #   _scrollView = _scrollView or @famous.find("#main-scroll-view")[0].renderNode
    #   if _scrollView and _scrollView._node
    #     page = _scrollView._node.index
    #     absPosition = _width * page + _scrollView.getPosition()
    #     perPosition = Math.max(0, Math.min(1, absPosition / (_width)))
    #     1 - perPosition

angular.module('simplecareersApp').controller('NewAppCtrl', NewAppCtrl)

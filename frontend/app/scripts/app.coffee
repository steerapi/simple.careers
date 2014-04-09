'use strict'

(->
  lastTime = 0
  vendors = [
    "webkit"
    "moz"
  ]
  x = 0

  while x < vendors.length and not window.requestAnimationFrame
    window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
    window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
    ++x
  unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = window.setTimeout(->
        callback currTime + timeToCall
        return
      , timeToCall)
      lastTime = currTime + timeToCall
      id
  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id
      return
  return
)()

window.rAF = window.requestAnimationFrame


((ionic) ->
  
  # Get transform origin poly
  d = document.createElement("div")
  transformKeys = [
    "webkitTransformOrigin"
    "transform-origin"
    "-webkit-transform-origin"
    "webkit-transform-origin"
    "-moz-transform-origin"
    "moz-transform-origin"
    "MozTransformOrigin"
    "mozTransformOrigin"
  ]
  TRANSFORM_ORIGIN = "webkitTransformOrigin"
  i = 0

  while i < transformKeys.length
    if d.style[transformKeys[i]] isnt `undefined`
      TRANSFORM_ORIGIN = transformKeys[i]
      break
    i++
  transitionKeys = [
    "webkitTransition"
    "transition"
    "-webkit-transition"
    "webkit-transition"
    "-moz-transition"
    "moz-transition"
    "MozTransition"
    "mozTransition"
  ]
  TRANSITION = "webkitTransition"
  i = 0

  while i < transitionKeys.length
    if d.style[transitionKeys[i]] isnt `undefined`
      TRANSITION = transitionKeys[i]
      break
    i++
  SwipeableCardController = ionic.controllers.ViewController.inherit(
    initialize: (opts) ->
      @cards = []
      ratio = window.innerWidth / window.innerHeight
      @maxWidth = window.innerWidth - (opts.cardGutterWidth or 0)
      @maxHeight = opts.height or 300
      @cardGutterWidth = opts.cardGutterWidth or 10
      @cardPopInDuration = opts.cardPopInDuration or 400
      @cardAnimation = opts.cardAnimation or "pop-in"
      return

    
    ###
    Push a new card onto the stack.
    ###
    pushCard: (card) ->
      self = this
      @cards.push card
      @beforeCardShow card
      card.transitionIn @cardAnimation
      setTimeout (->
        card.disableTransition self.cardAnimation
        return
      ), @cardPopInDuration + 100
      return

    
    ###
    Set up a new card before it shows.
    ###
    beforeCardShow: ->
      nextCard = @cards[@cards.length - 1]
      return  unless nextCard
      
      # Calculate the top left of a default card, as a translated pos
      topLeft = window.innerHeight / 2 - @maxHeight / 2
      # console.log window.innerHeight, @maxHeight
      cardOffset = Math.min(@cards.length, 3) * 5
      
      # Move each card 5 pixels down to give a nice stacking effect (max of 3 stacked)
      nextCard.setY nextCard.y-cardOffset
      nextCard.setPopInDuration @cardPopInDuration
      nextCard.setZIndex @cards.length*10
      return

    
    ###
    Pop a card from the stack
    ###
    popCard: (animate) ->
      card = @cards.pop()
      card.swipe()  if animate
      card
  )
  SwipeableCardView = ionic.views.View.inherit(
    
    ###
    Initialize a card with the given options.
    ###
    initialize: (opts) ->
      opts = ionic.extend({}, opts)
      ionic.extend this, opts
      @el = opts.el
      @startX = @startY = @x = @y = 0
      @bindEvents()
      return

    ###
    Set the X position of the card.
    ###
    setX: (x) ->
      @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + x + "px," + @y + "px, 0)"
      @x = x
      @startX = x
      return

    
    ###
    Set the Y position of the card.
    ###
    setY: (y) ->
      @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @x + "px," + y + "px, 0)"
      @y = y
      @startY = y
      return

    
    ###
    Set the Z-Index of the card
    ###
    setZIndex: (index) ->
      @el.style.zIndex = index
      return

    
    ###
    Set the width of the card
    ###
    setWidth: (width) ->
      @el.style.width = width + "px"
      return

    
    ###
    Set the height of the card
    ###
    setHeight: (height) ->
      @el.style.height = height + "px"
      return

    
    ###
    Set the duration to run the pop-in animation
    ###
    setPopInDuration: (duration) ->
      @cardPopInDuration = duration
      return

    
    ###
    Transition in the card with the given animation class
    ###
    transitionIn: (animationClass) ->
      self = this
      @el.classList.add animationClass + "-start"
      @el.classList.add animationClass
      @el.style.display = "block"
      setTimeout (->
        self.el.classList.remove animationClass + "-start"
        return
      ), 100
      return

    
    ###
    Disable transitions on the card (for when dragging)
    ###
    disableTransition: (animationClass) ->
      @el.classList.remove animationClass
      return

    
    ###
    Swipe a card out programtically
    ###
    swipe: ->
      @transitionOut()
      return

    
    ###
    Fly the card out or animate back into resting position.
    ###
    transitionOut: ->
      self = this
      console.log "@x", @x
      if (@x > -50) and (@x < 50)
        @el.style[TRANSITION] = "-webkit-transform 0.2s ease-in-out"
        @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @startX + "px," + (@y) + "px, 0)"
        setTimeout (->
          self.el.style[TRANSITION] = "none"
          return
        ), 200
      else
      # Fly out
        console.log "flyout"
        rotateTo = (@rotationAngle + (@rotationDirection * 0.6)) or (Math.random() * 0.4)
        duration = (if @rotationAngle then 0.2 else 0.5)
        @el.style[TRANSITION] = "-webkit-transform " + duration + "s ease-in-out"
        
        console.log "window.innerWidth: ",window.innerWidth
        if (@x < -50)
          @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + (-window.innerWidth * 3) + "px," + @y + "px, 0) rotate(" + rotateTo + "rad)"
        else
          @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + (window.innerWidth * 3) + "px," + @y + "px, 0) rotate(" + rotateTo + "rad)"
          
        @onSwipe and @onSwipe()
        
        # Trigger destroy after card has swiped out
        setTimeout (->
          self.onDestroy and self.onDestroy()
          return
        ), duration * 1000
      return

    
    ###
    Bind drag events on the card.
    ###
    bindEvents: ->
      self = this
      ionic.onGesture "dragstart", ((e) ->
        cx = window.innerWidth / 2
        if e.gesture.touches[0].pageX < cx
          self._transformOriginRight()
        else
          self._transformOriginLeft()
        window.rAF ->
          self._doDragStart e
          return

        return
      ), @el
      ionic.onGesture "drag", ((e) ->
        window.rAF ->
          self._doDrag e
          return

        return
      ), @el
      ionic.onGesture "dragend", ((e) ->
        window.rAF ->
          self._doDragEnd e
          return

        return
      ), @el
      return

    
    # Rotate anchored to the left of the screen
    _transformOriginLeft: ->
      @el.style[TRANSFORM_ORIGIN] = "left center"
      @rotationDirection = 1
      return

    _transformOriginRight: ->
      @el.style[TRANSFORM_ORIGIN] = "right center"
      @rotationDirection = -1
      return

    _doDragStart: (e) ->
      width = @el.offsetWidth
      point = window.innerWidth / 2 + @rotationDirection * (width / 2)
      distance = Math.abs(point - e.gesture.touches[0].pageX) # - window.innerWidth/2);
      console.log distance
      @touchDistance = distance * 10
      console.log "Touch distance", @touchDistance #this.touchDistance, width);
      return

    _doDrag: (e) ->
      o = e.gesture.deltaX / 3
      @rotationAngle = Math.atan(o / @touchDistance) * @rotationDirection
      @rotationAngle = 0  if e.gesture.deltaX < 0
      @x = @startX + (e.gesture.deltaX)
      @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @x + "px, " + @y + "px, 0) rotate(" + (@rotationAngle or 0) + "rad)"
      return

    _doDragEnd: (e) ->
      @transitionOut e
      return
  )
  
  # Instantiate our card view
  angular.module("ionic.contrib.ui.cards", ["ionic"]).directive("swipeCard", [
    "$timeout"
    ($timeout) ->
      return (
        restrict: "E"
        template: "<div class=\"swipe-card\" ng-transclude></div>"
        require: "^swipeCards"
        replace: true
        transclude: true
        scope:
          onSwipe: "&"
          onDestroy: "&"

        compile: (element, attr) ->
          ($scope, $element, $attr, swipeCards) ->
            el = $element[0]
            swipeableCard = new SwipeableCardView(
              el: el
              onSwipe: ->
                $timeout ->
                  $scope.onSwipe()
                  return

                return

              onDestroy: ->
                $timeout ->
                  $scope.onDestroy()
                  return

                return
            )
            $scope.$parent.swipeCard = swipeableCard
            swipeCards.pushCard swipeableCard
            return
      )
  ]).directive("swipeCards", [
    "$rootScope"
    ($rootScope) ->
      return (
        restrict: "E"
        template: "<div class=\"swipe-cards\" ng-transclude></div>"
        replace: true
        transclude: true
        scope: {}
        controller: ($scope, $element) ->
          swipeController = new SwipeableCardController({})
          $rootScope.$on "swipeCard.pop", (isAnimated) ->
            swipeController.popCard isAnimated
            return

          swipeController
      )
  ]).factory "$ionicSwipeCardDelegate", [
    "$rootScope"
    ($rootScope) ->
      return (
        popCard: ($scope, isAnimated) ->
          $rootScope.$emit "swipeCard.pop", isAnimated
          return

        getSwipebleCard: ($scope) ->
          $scope.$parent.swipeCard
      )
  ]
  return
) window.ionic


angular
  .module('simplecareersApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    # 'ngRoute',
    # 'ui.router',
    'ionic',
    'ionic.contrib.ui.cards',
    'restangular'
  ])
  .config([
    'RestangularProvider'
  	'$stateProvider'
    '$urlRouterProvider'
  	(RestangularProvider, $stateProvider, $urlRouterProvider, config) ->
      RestangularProvider.setRestangularFields
        id: "_id"
      RestangularProvider.setBaseUrl "http://mobile.fairsey.com/data/v1/"
        
      $urlRouterProvider.otherwise "/intro/page"
      $stateProvider
      .state('intro',
        url: "/intro",
        views: 
          {
            'main': {
              templateUrl: "/views/intro/intro.html",
              controller: "IntroCtrl"
            }
          }
      )
      .state('intro.page',
        url: "/page",
        views: 
          {
            'main.intro': {
              templateUrl: "/views/intro/intro-page.html",
              controller: "IntroPageCtrl"
            }
          }
      )
      .state('app',
        url: "/app",
        views: 
          {
            'main': {
              templateUrl: "/views/app/app.html",
              controller: "AppCtrl"
            }
          }
      )
      # .state('app.job',
      #   url: "/job",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
      # .state('app.profile',
      #   url: "/profile",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
      # .state('app.applied',
      #   url: "/applied",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
      # .state('app.inbox',
      #   url: "/inbox",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
  ])

    # $stateProvider.state("tab",
    #   url: "/tab"
    #   abstract: true
    #   templateUrl: "views/tabs.html"
    # ).state("tab.dash",
    #   url: "/dash"
    #   views:
    #     "tab-dash":
    #       templateUrl: "views/tab-dash.html"
    #       controller: "DashCtrl"
    # ).state("tab.friends",
    #   url: "/friends"
    #   views:
    #     "tab-friends":
    #       templateUrl: "views/tab-friends.html"
    #       controller: "FriendsCtrl"
    # ).state("tab.friend-detail",
    #   url: "/friend/:friendId"
    #   views:
    #     "tab-friends":
    #       templateUrl: "views/friend-detail.html"
    #       controller: "FriendDetailCtrl"
    # ).state "tab.account",
    #   url: "/account"
    #   views:
    #     "tab-account":
    #       templateUrl: "views/tab-account.html"
    #       controller: "AccountCtrl"
    # 
    # $urlRouterProvider.otherwise "/tab/dash"
    # 
    # $urlRouterProvider.otherwise "/"
    # $stateProvider.state "index",
    #   url: "/"
    #   templateUrl: "views/main.html"
    #   controller: "MainCtrl"

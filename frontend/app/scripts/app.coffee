'use strict'

# rAF shim
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

# ionic swipe

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
      # # console.log window.innerHeight, @maxHeight
      cardOffset = Math.min(@cards.length, 3) * 5
      
      # Move each card 5 pixels down to give a nice stacking effect (max of 3 stacked)
      # nextCard.setY nextCard.y-cardOffset
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
      @enable = true
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

    setEnable:(state)->
      @enable = state
    
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
      # # console.log "@x", @x
      if (@x > -50) and (@x < 50)
      # if @y < 50
        @el.style[TRANSITION] = "-webkit-transform 0.2s ease-in-out"
        @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @startX + "px," + (@startY) + "px, 0)"
        setTimeout (->
          self.el.style[TRANSITION] = "none"
          return
        ), 200
      else
      # Fly out
        # # console.log "flyout"
        rotateTo = (@rotationAngle + (@rotationDirection * 0.6)) or (Math.random() * 0.4)
        duration = (if @rotationAngle then 0.3 else 0.5)
        @el.style[TRANSITION] = "-webkit-transform " + duration + "s ease-in-out"
        
        # # console.log "window.innerWidth: ",window.innerWidth
        # # console.log "@y", @y
        if (@x < -50)
          # @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @x + "px," + -(window.innerHeight * 1.5) + "px, 0) rotate(" + rotateTo + "rad)"
          @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @x + "px," + (window.innerHeight * 3) + "px, 0) rotate(" + rotateTo + "rad)"
          @onSwipeLeft and @onSwipeLeft()        
        else
          # @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @x + "px," + (window.innerHeight * 3) + "px, 0) rotate(" + rotateTo + "rad)"
          @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @x + "px," + (window.innerHeight * 3) + "px, 0) rotate(" + rotateTo + "rad)"
          @onSwipeRight and @onSwipeRight()
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
      ionic.onGesture "dragstart", ((e) =>
        if not @enable
          return
        e.preventDefault()
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
      ionic.onGesture "drag", ((e) =>
        if not @enable
          return
        e.preventDefault()
        window.rAF ->
          self._doDrag e
          return

        return
      ), @el
      ionic.onGesture "dragend", ((e) =>
        if not @enable
          return
        e.preventDefault()
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
      distance = Math.abs(point - e.gesture.touches[0].pageY) # - window.innerWidth/2);
      # # console.log distance
      @touchDistance = distance * 10
      # # console.log "Touch distance", @touchDistance #this.touchDistance, width);
      @onDragStart()
      return

    _doDrag: (e) ->
      o = e.gesture.deltaY / 3
      @rotationAngle = Math.atan(o / @touchDistance) * @rotationDirection
      @rotationAngle = 0  if e.gesture.deltaY < 0
      @x = @startX + (e.gesture.deltaX)
      @y = @startY + (e.gesture.deltaY)
      @el.style[ionic.CSS.TRANSFORM] = "translate3d(" + @x + "px, " + @y + "px, 0) rotate(" + (@rotationAngle or 0) + "rad)"
      @onDrag(@x,@y)
      return

    _doDragEnd: (e) ->
      @onDragEnd()
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
          onDragging: "&"
          onDragStart: "&"
          onDragEnd: "&"
          onSwipeLeft: "&"
          onSwipeRight: "&"
          onSwipe: "&"
          onDestroy: "&"

        compile: (element, attr) ->
          ($scope, $element, $attr, swipeCards) ->
            el = $element[0]
            swipeableCard = new SwipeableCardView(
              el: el
              onDrag: (x,y)->
                $timeout ->
                  $scope.onDragging?({
                    $x:x
                    $y:y
                  })
                  return

                return
              onDragStart: (x,y)->
                $timeout ->
                  $scope.onDragStart?()
                  return

                return
              onDragEnd: (x,y)->
                $timeout ->
                  $scope.onDragEnd?()
                  return

                return
              onSwipeRight: ->
                $timeout ->
                  $scope.onSwipeRight?()
                  return

                return
              onSwipeLeft: ->
                $timeout ->
                  $scope.onSwipeLeft?()
                  return

                return
              onSwipe: ->
                $timeout ->
                  $scope.onSwipe?()
                  return

                return

              onDestroy: ->
                $timeout ->
                  $scope.onDestroy?()
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


app = angular
  .module('simplecareersApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngSocial',
    # 'ngRoute',
    # 'ui.router',
    'ionic',
    'ionic.contrib.ui.cards',
    'restangular',
    'angulartics',
    # 'angulartics.google.analytics',
    'angulartics.segment.io'
  ])
  .config([
    '$locationProvider'
    'RestangularProvider'
  	'$stateProvider'
    '$urlRouterProvider'
  	($locationProvider, RestangularProvider, $stateProvider, $urlRouterProvider, config) ->
      $locationProvider.html5Mode(true);
      # $locationProvider
      #   .html5Mode(false)
      #   .hashPrefix('!');
        
      RestangularProvider.setRestangularFields
        id: "_id"
      RestangularProvider.setBaseUrl "http://api.simple.careers/data/v1/"
      
      page = localStorage.getItem "page"
      if not page
        page = 0
      $urlRouterProvider.otherwise "/app/all/#{page}"
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
      .state('app.all',
        url: "/all",
        views: 
          {
            'main.view': {
              templateUrl: "/views/app/item.html",
              controller: "AppItemCtrl"
            }
          }
      )
      .state('app.all.job',
        url: "/:jobId",
        views: 
          {
            'main.view.view': {
              templateUrl: "/views/app/job.html",
              controller: "AppAllJobCtrl"
            }
          }
      )
      .state('app.favorite',
        url: "/favorite",
        views: 
          {
            'main.view': {
              templateUrl: "/views/app/item.html",
              controller: "AppItemCtrl"
            }
          }
      )
      .state('app.favorite.job',
        url: "/:jobId",
        views: 
          {
            'main.view.view': {
              templateUrl: "/views/app/job.html",
              controller: "AppFavoriteJobCtrl"
            }
          }
      )
      .state('app.apply',
        url: "/apply",
        views: 
          {
            'main.view': {
              templateUrl: "/views/app/item.html",
              controller: "AppItemCtrl"
            }
          }
      )
      .state('app.apply.job',
        url: "/:jobId",
        views: 
          {
            'main.view.view': {
              templateUrl: "/views/app/job.html",
              controller: "AppApplyJobCtrl"
            }
          }
      )
      .state('app.login',
        url: "/?userId&token&redirect",
        views:
          {
            'main.view': {
              templateUrl: "/views/app/login.html",
              controller: "AppLoginCtrl"
            }
          }
      )
      .state('app.logout',
        url: "/logout",
        views: 
          {
            'main.view': {
              templateUrl: "/views/app/logout.html",
              controller: "AppLogoutCtrl"
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


app.factory "preloader", ["$q","$rootScope",($q, $rootScope) ->

  # I manage the preloading of image objects. Accepts an array of image URLs.
  Preloader = (imageLocations) ->

    # I am the image SRC values to preload.
    @imageLocations = imageLocations

    # As the images load, we'll need to keep track of the load/error
    # counts when announing the progress on the loading.
    @imageCount = @imageLocations.length
    @loadCount = 0
    @errorCount = 0

    # I am the possible states that the preloader can be in.
    @states =
      PENDING: 1
      LOADING: 2
      RESOLVED: 3
      REJECTED: 4


    # I keep track of the current state of the preloader.
    @state = @states.PENDING

    # When loading the images, a promise will be returned to indicate
    # when the loading has completed (and / or progressed).
    @deferred = $q.defer()
    @promise = @deferred.promise
    return

  # ---
  # STATIC METHODS.
  # ---

  # I reload the given images [Array] and return a promise. The promise
  # will be resolved with the array of image locations.
  Preloader.preloadImages = (imageLocations) ->
    preloader = new Preloader(imageLocations)
    preloader.load()


  # ---
  # INSTANCE METHODS.
  # ---
  Preloader:: =

    # Best practice for "instnceof" operator.
    constructor: Preloader

    # ---
    # PUBLIC METHODS.
    # ---

    # I determine if the preloader has started loading images yet.
    isInitiated: isInitiated = ->
      @state isnt @states.PENDING


    # I determine if the preloader has failed to load all of the images.
    isRejected: isRejected = ->
      @state is @states.REJECTED


    # I determine if the preloader has successfully loaded all of the images.
    isResolved: isResolved = ->
      @state is @states.RESOLVED


    # I initiate the preload of the images. Returns a promise.
    load: load = ->
  
      # If the images are already loading, return the existing promise.
      return (@promise)  if @isInitiated()
      @state = @states.LOADING
      i = 0

      while i < @imageCount
        @loadImageLocation @imageLocations[i]
        i++
  
      # Return the deferred promise for the load event.
      @promise


    # ---
    # PRIVATE METHODS.
    # ---

    # I handle the load-failure of the given image location.
    handleImageError: handleImageError = (imageLocation) ->
      @errorCount++
  
      # If the preload action has already failed, ignore further action.
      return  if @isRejected()
      @state = @states.REJECTED
      @deferred.reject imageLocation
      return


    # I handle the load-success of the given image location.
    handleImageLoad: handleImageLoad = (imageLocation) ->
      @loadCount++
  
      # If the preload action has already failed, ignore further action.
      return  if @isRejected()
  
      # Notify the progress of the overall deferred. This is different
      # than Resolving the deferred - you can call notify many times
      # before the ultimate resolution (or rejection) of the deferred.
      @deferred.notify
        percent: Math.ceil(@loadCount / @imageCount * 100)
        imageLocation: imageLocation

  
      # If all of the images have loaded, we can resolve the deferred
      # value that we returned to the calling context.
      if @loadCount is @imageCount
        @state = @states.RESOLVED
        @deferred.resolve @imageLocations
      return


    # I load the given image location and then wire the load / error
    # events back into the preloader instance.
    # --
    # NOTE: The load/error events trigger a $digest.
    loadImageLocation: loadImageLocation = (imageLocation) ->
      preloader = this
  
      # When it comes to creating the image object, it is critical that
      # we bind the event handlers BEFORE we actually set the image
      # source. Failure to do so will prevent the events from proper
      # triggering in some browsers.
  
      # Since the load event is asynchronous, we have to
      # tell AngularJS that something changed.
  
      # Clean up object reference to help with the
      # garbage collection in the closure.
  
      # Since the load event is asynchronous, we have to
      # tell AngularJS that something changed.
  
      # Clean up object reference to help with the
      # garbage collection in the closure.
      image = $(new Image()).load((event) ->
        $rootScope.$apply ->
          preloader.handleImageLoad event.target.src
          preloader = image = event = null
          return

        return
      ).error((event) ->
        $rootScope.$apply ->
          preloader.handleImageError event.target.src
          preloader = image = event = null
          return

        return
      ).prop("src", imageLocation)
      return


  # Return the factory instance.
  Preloader
]
'use strict'

class AppFavoriteJobCtrl extends AppCommonJobCtrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader", "$window"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader, @window) ->
    super @scope, @stateParams, @state, @Restangular, @timeout, @preloader
    @type = "favorite"
    @scope.$emit "setEnableShare", false
    @checkLogin @scope,@Restangular, (user)=>
      @scope.user = user
      @init()
  init:=>
    @skip = +@state.params.jobId
    @resource = @Restangular.all("userfavorites")
    @resource.getList( @newQuery(@skip) ).then (userfavorites)=>
      @scope.job = userfavorites[0].job
      @scope.$emit "shareUrl", window.location.href
      @scope.job.$$flip = false
      @scope.isLoading = true
      @scope.status = "loading"
      if not @isValid(@scope.job)
        @scope.status = "broken"
        return
      @preloader.preloadImages([@scope.job.picture.url]).then =>
        @scope.status = "normal"
        @scope.isLoading = false
        @scope.isSuccessful = true
      , =>
        @scope.status = "normal"
        @scope.isLoading = false
        @scope.isSuccessful = false        
    , =>
      # console.log "skip", @skip
      if +@skip == 0
        # # console.log "status 0"
        @scope.status = "empty"
        @scope.swipeCard.setEnable false
        return
      @skip=0
      window.location.href = "/app/#{@type}/#{@skip}"
    @initButtonEvents()      
  newQuery: (sk)=>
    query = super sk
    query.populate = "job"
    return query
  cardSwipedLeft: (job)=>
    @skip--
    super job
    @timeout =>
      @purgeJobCache()
      # refresh
      location.reload()
    , 110
  cardSwipedRight: (job)=>
    super job
    
angular.module('simplecareersApp').controller 'AppFavoriteJobCtrl', AppFavoriteJobCtrl
  

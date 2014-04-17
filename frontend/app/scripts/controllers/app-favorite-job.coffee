'use strict'

class AppFavoriteJobCtrl extends AppCommonJobCtrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader","$analytics"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics) ->
    super @scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics
    @type = "favorite"
    @scope.$emit "setEnableShare", false
    @checkLogin @scope,@Restangular, (user)=>
      if not user
        @scope.status = "loading"
        return
      @init()
  init:=>
    @skip = +@state.params.jobId
    @resource = @Restangular.all("userfavorites")
    @resource.getList( @newQuery(@skip) ).then (userfavorites)=>
      @scope.job = userfavorites[0].job
      if not @scope.job
        @scope.status = "broken"
        return
      @checkApplied()
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
      @state.go "app.#{@type}.job", jobId:@skip
    @initButtonEvents()      
  newQuery: (sk)=>
    query = super sk
    query.conditions =
      user: @scope.user._id
    query.populate = "job"
    return query
  cardSwipedLeft: (job)=>
    @skip--
    super job
    @timeout =>
      @purgeJobCache()
      # refresh
      # location.reload()
      @state.go "app.favorite.job", @stateParams.jobId, { reload: true }
    , 110
  cardSwipedRight: (job)=>
    super job
    
angular.module('simplecareersApp').controller 'AppFavoriteJobCtrl', AppFavoriteJobCtrl
  

'use strict'

class AppApplyJobCtrl extends AppCommonJobCtrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader) ->
    super @scope, @stateParams, @state, @Restangular, @timeout, @preloader
    @type = "apply"
    @scope.$emit "setEnableShare", false
    @checkLogin @scope,@Restangular, (user)=>
      @scope.user = user
      @init()
  init:=>
    @skip = +@state.params.jobId
    @resource = @Restangular.all("userapplies")
    @resource.getList( @newQuery(@skip) ).then (userapplies)=>
      @scope.job = userapplies[0].job
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
      # console.log "err", @skip
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
  # newQuery: =>
  #   query = 
  #     conditions:
  #       _id:
  #         $in: [] #"53499c80a696d802005caaab"
  #     sort: "order"
  #     skip: @skip
  #     limit: 1
  #   return query

angular.module('simplecareersApp').controller 'AppApplyJobCtrl', AppApplyJobCtrl
  

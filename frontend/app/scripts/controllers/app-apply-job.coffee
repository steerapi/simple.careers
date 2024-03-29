'use strict'

class AppApplyJobCtrl extends AppCommonJobCtrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader","$analytics"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics) ->
    super @scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics
    @type = "apply"
    @scope.$emit "setEnableShare", false
    @checkLogin @scope,@Restangular, (user)=>
      if not user
        @scope.status = "loading"
        return
      @init "userapplies", (userapplies)=>
        return userapplies[0].job
        
  # init:=>
  #   @skip = +@state.params.jobId
  #   @scope.status = "loading"
  #   @resource = @Restangular.all("userapplies")
  #   @resource.getList( @newQuery(@skip) ).then (userapplies)=>
  #     @scope.job = userapplies[0].job
  #     if not @scope.job
  #       @scope.status = "broken"
  #       return
  #     @checkApplied(@scope.job)
  #     @scope.$emit "shareUrl", window.location.href
  #     @scope.job.$$flip = false
  #     @scope.isLoading = true
  #     @scope.status = "loading"
  #     if not @isValid(@scope.job)
  #       @scope.status = "broken"
  #       return
  #     @preloader.preloadImages([@scope.job.picture.url]).then =>
  #       @scope.status = "normal"
  #       @scope.isLoading = false
  #       @scope.isSuccessful = true
  #     , =>
  #       @scope.status = "normal"
  #       @scope.isLoading = false
  #       @scope.isSuccessful = false        
  #   , =>
  #     # console.log "err", @skip
  #     if +@skip == 0
  #       # # console.log "status 0"
  #       @scope.status = "empty"
  #       @scope.swipeCard.setEnable false
  #       return
  #     @skip=0
  #     @state.go "app.#{@type}.job", jobId:@skip
  #   @initButtonEvents()      
  newQuery: (sk)=>
    query = super sk
    query.conditions =
      user: @scope.user._id
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
  

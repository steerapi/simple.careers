'use strict'

class AppCommonJobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader) ->
    super @scope
    @scope.$state = @state
    # @init()
  init:=>
    @skip = +@state.params.jobId
    # query = @newQuery()
    # query.count = true
    # @Restangular.all("jobs").customGET("",query)
    # .then (count)=>
    #   if count <= 0
    #     @scope.status = "empty"
    #     return
    # # console.log "sk",@newQuery(+@skip)
    # # console.log "sk",@newQuery(+@skip+1)
    # # console.log "sk",@newQuery(+@skip+2)
    @jobRequest @Restangular, @preloader.preloadImages, @newQuery(+@skip), (jobs)=>
      @jobRequest @Restangular, @preloader.preloadImages, @newQuery(+@skip+1)
    # @resource = @Restangular.all("jobs")
    # @resource.getList( @newQuery() ).then (jobs)=>      
      if jobs and jobs.length > 0
        @scope.job = jobs[0]
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
      # # console.log "err", @skip
      if +@skip == 0
        # # console.log "status 0"
        @scope.status = "empty"
        @scope.swipeCard.setEnable false
        return
      @skip=0
      window.location.hash = "/app/#{@type}/#{@skip}"
    @initButtonEvents()
    
  initButtonEvents:=>
    @noLis?()
    @noLis = @scope.$on "noClick",=>
      if not @scope.swipeCard.enable
        return
      @scope.status = "pass"
      @scope.swipeCard.setX -500
      @scope.swipeCard.transitionOut()
    @yesLis?()
    @yesLis =@scope.$on "yesClick",=>
      if not @scope.swipeCard.enable
        return
      @scope.status = "fav"
      @scope.swipeCard.setX 500
      @scope.swipeCard.transitionOut()
    
  newQuery: (sk)=>
    query = 
      sort: "order"
      skip: sk
      limit: 1
    return query
  cardDestroyed: (index)=>
    # @scope.jobs.splice(index, 1);
  cardSwipedLeft: (job)=>
    @checkLogin @scope,@Restangular, (user)=>
      @scope.user = user
      @Restangular.all("userfavorites").remove
        conditions:
          user: user._id
          job: @scope.job._id
  cardSwipedRight: (job)=>
    @checkLogin @scope,@Restangular, (user)=>
      @scope.user = user
      @Restangular.all("userfavorites").post
        user: user._id
        job: @scope.job._id
  cardDragStart: (job)=>
  cardDragEnd: (job)=>
    @dragging = false
  isValid: (job)=>
    return false if not job
    return job.position and job.companyname and job.logo and job.location and job.type and job.picture
  cardDrag: (x,y,job)=>
    @dragging = true
    if x<-50
      @scope.status = "pass"
    else if x>50
      @scope.status = "fav"
    else
      if not @isValid(@scope.job)
        @scope.status = "broken"
      else
        @scope.status = "normal"
    # # console.log "Drag", arguments...
  cardSwiped: (index)=>
    # @count++
    @timeout =>
      @skip++
      window.location.hash = "/app/#{@type}/#{@skip}"
    , 100
  flipClick: (job)=>
    # # console.log "flipClick"
    if not @applyClicked and not @dragging
      job?.$$flip = not job?.$$flip
    @applyClicked = false
  apply: (event)=>
    # # console.log "apply"
    event.preventDefault()
    @applyClicked = true
    # console.log window.location.hash
    window.location = "/auth/linkedin?redirect=#{window.location.hash.replace "#",""}&apply=#{@scope.job._id}"
    return

window.AppCommonJobCtrl = AppCommonJobCtrl
# angular.module('simplecareersApp').controller 'AppCommonJobCtrl', AppCommonJobCtrl
  

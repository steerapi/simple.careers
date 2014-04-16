'use strict'

class AppCommonJobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader","$analytics"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics) ->
    super @scope
    if not localStorage.getItem("visited")
      @state.go "intro.page", pageId:0
    
    @scope.$state = @state
    # @init()
  checkApplied: =>
    if @isLogin()
      if @scope.user
        resource = @Restangular.all("userapplies")
        resource.getList( 
          conditions:
            job: @scope.job._id
            user: @scope.user._id
        ).then (userapplies)=>
          if userapplies and userapplies.length > 0 
            @scope.job.$$applied = true
      else
        @checkLogin @scope,@Restangular,(user)=>
          resource = @Restangular.all("userapplies")
          resource.getList( 
            conditions:
              job: @scope.job._id
              user: user._id
          ).then (userapplies)=>
            if userapplies and userapplies.length > 0 
              @scope.job.$$applied = true    
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
      # # console.log "err", @skip
      if +@skip == 0
        # # console.log "status 0"
        @scope.status = "empty"
        @scope.swipeCard.setEnable false
        return
      @skip=0
      @state.go "app.#{@type}.job", jobId:@skip
    @initButtonEvents()
    
  initButtonEvents:=>
    @noLis?()
    @noLis = @scope.$on "noClick",=>
      if not @scope.swipeCard.enable
        return

      eventData = 
        job: 
          _id: @scope.job._id
          position: @scope.job.position
          companyname: @scope.job.companyname
      eventData.type = @type if @type
      if @scope.user
        eventData.user = @scope.user.username
      @analytics.eventTrack "passClick", eventData
      
      @scope.status = "pass"
      @scope.swipeCard.setX -500
      @scope.swipeCard.transitionOut()
    @yesLis?()
    @yesLis =@scope.$on "yesClick",=>
      if not @scope.swipeCard.enable
        return

      eventData = 
        job: 
          _id: @scope.job._id
          position: @scope.job.position
          companyname: @scope.job.companyname
      eventData.type = @type if @type
      if @scope.user
        eventData.user = @scope.user.username
      @analytics.eventTrack "favClick", eventData
  
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
    eventData = 
      job: 
        _id: @scope.job._id
        position: @scope.job.position
        companyname: @scope.job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    @analytics.eventTrack "passSwipe", eventData
    
    if not @isLogin()
      @skip++
      @timeout =>
        @state.go "app.#{@type}.job", jobId:@skip
      , 100
      return
    @checkLogin @scope, @Restangular, (user)=>
      @Restangular.all("userfavorites").remove
        conditions:
          user: user._id
          job: @scope.job._id
      @timeout =>
        @skip++
        @state.go "app.#{@type}.job", jobId:@skip
      , 100      

  cardSwipedRight: (job)=>
    eventData = 
      job: 
        _id: @scope.job._id
        position: @scope.job.position
        companyname: @scope.job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    @analytics.eventTrack "favSwipe", eventData
    
    @checkLogin @scope, @Restangular, (user)=>
      if not user
        return
      @Restangular.all("userfavorites").post
        user: user._id
        job: @scope.job._id
      @timeout =>
        @skip++
        @state.go "app.#{@type}.job", jobId:@skip
      , 100
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
    # @timeout =>
#       @skip++
#       window.location.hash = "/app/#{@type}/#{@skip}"
#     , 100
  flipClick: (job)=>
    eventData = 
      job: 
        _id: @scope.job._id
        position: @scope.job.position
        companyname: @scope.job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    @analytics.eventTrack "flipClick", eventData

    # # console.log "flipClick"
    if not @applyClicked and not @dragging
      job?.$$flip = not job?.$$flip
    @applyClicked = false
  apply: (event)=>
    eventData = 
      job: 
        _id: @scope.job._id
        position: @scope.job.position
        companyname: @scope.job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    @analytics.eventTrack "applyClick", eventData
    
    # # console.log "apply"
    event.preventDefault()
    @applyClicked = true
    # # console.log window.location.hash
    
    userId = localStorage.getItem("userId");
    token = localStorage.getItem("token");
    # # console.log "check",userId,token
    if (not userId) or (not token)
      window.location.href = "/auth/linkedin?redirect=#{window.location.href}&apply=#{@scope.job._id}"
      return
    else
      resource = @Restangular.all "userapplies"
      resource.post
        user: userId
        job: @scope.job._id
      @scope.job.$$applied = true
      
window.AppCommonJobCtrl = AppCommonJobCtrl
# angular.module('simplecareersApp').controller 'AppCommonJobCtrl', AppCommonJobCtrl
  

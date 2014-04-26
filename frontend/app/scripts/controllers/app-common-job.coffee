'use strict'

class AppCommonJobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader","$analytics"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics) ->
    super @scope
    @scope.$state = @state
    # @init()
  checkApplied: (job)=>
    if @isLogin()
      if @scope.user
        resource = @Restangular.all("userapplies")
        resource.getList( 
          conditions:
            job: job._id
            user: @scope.user._id
        ).then (userapplies)=>
          if userapplies and userapplies.length > 0 
            job.$$applied = true
        , @errHandler
      else
        @checkLogin @scope,@Restangular,(user)=>
          if not user
            return          
          resource = @Restangular.all("userapplies")
          resource.getList( 
            conditions:
              job: job._id
              user: user._id
          ).then (userapplies)=>
            if userapplies and userapplies.length > 0 
              job.$$applied = true
          , @errHandler
  init:(collection="jobs", extractor=((jobs)->return jobs[0]))=>
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
    @scope.status = "loading"
    @jobRequest @Restangular, collection, @preloader.preloadImages, @newQuery(+@skip), extractor,(jobs)=>
      @jobRequest @Restangular, collection, @preloader.preloadImages, @newQuery(+@skip+1), extractor,(jobs)=>
        @timeout =>
          # console.log jobs
          @scope.$emit "jobswap", jobs[0]
        , 100
      , =>
        @timeout =>
          # console.log jobs
          @scope.$emit "jobswap", {$$status:"loading"}
        , 100
        
    # @resource = @Restangular.all("jobs")
    # @resource.getList( @newQuery() ).then (jobs)=>      
      if jobs and jobs.length > 0
        # @scope.jobs = jobs        
        @scope.job = jobs[0]
        if not @scope.job
          @scope.status = "broken"
          return
        @checkApplied(@scope.job)
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
      @initButtonEvents(@scope.job)
    , =>
      # # console.log "err", @skip
      if +@skip == 0
        # # console.log "status 0"
        @scope.status = "empty"
        @scope.swipeCard.setEnable false
        return
      @skip=0
      @state.go "app.#{@type}.job", jobId:@skip
    
  initButtonEvents:(job)=>
    @noLis?()
    @noLis = @scope.$on "noClick",=>
      if not @scope.swipeCard.enable
        return

      eventData = 
        job: 
          _id: job._id
          position: job.position
          companyname: job.companyname
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
          _id: job._id
          position: job.position
          companyname: job.companyname
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
    if not @scope.loggingIn
      @skip++
      @state.go "app.#{@type}.job", jobId:@skip
  
  cardSwipedLeft: (job)=>
    eventData = 
      job: 
        _id: job._id
        position: job.position
        companyname: job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    @analytics.eventTrack "passSwipe", eventData
    
    if not @isLogin()
      # @skip++
      # @timeout =>
      #   @state.go "app.#{@type}.job", jobId:@skip
      # , 100
      return
    @checkLogin @scope, @Restangular, (user)=>
      if not user
        return
      @Restangular.all("userfavorites").remove
        conditions:
          user: user._id
          job: job._id
      .then =>
        console.log ""
      , @errHandler 
      # @timeout =>
      #   @skip++
      #   @state.go "app.#{@type}.job", jobId:@skip
      # , 100

  cardSwipedRight: (job)=>
    eventData = 
      job: 
        _id: job._id
        position: job.position
        companyname: job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    @analytics.eventTrack "favSwipe", eventData
    
    @checkLogin @scope, @Restangular, (user)=>
      if not user
        # @loggingIn = true
        return
      @Restangular.all("userfavorites").post
        user: user._id
        job: job._id
      .then =>
        console.log ""
      , @errHandler
      # @timeout =>
      #   @skip++
      #   @state.go "app.#{@type}.job", jobId:@skip
      # , 100
  cardDragStart: (job)=>
  cardDragEnd: (job)=>
    @dragging = false
  isValid: (job)=>
    return false if not job
    return job.position and job.companyname and job.logo and job.location and job.type and job.picture
  cardDrag: (x,y,job)=>
    @dragging = true
    if not (@scope.status == "normal" or @scope.status == "pass" or @scope.status == "fav")
      return
    if x<-50
      @scope.status = "pass"
    else if x>50
      @scope.status = "fav"
    else
      if not @isValid(job)
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
    if not job
      return
    eventData = 
      job: 
        _id: job._id
        position: job.position
        companyname: job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    @analytics.eventTrack "flipClick", eventData

    # # console.log "flipClick"
    if not @applyClicked and not @dragging
      job?.$$flip = not job?.$$flip
      @scope.swipeCard.setEnable(not job?.$$flip)
      if not job?.$$flip
        @scope.status = "normal"
      
    @applyClicked = false
  apply: (event,job)=>
    @login()
    
    event.preventDefault()
    @applyClicked = true

    eventData = 
      job: 
        _id: job._id
        position: job.position
        companyname: job.companyname
    eventData.type = @type if @type
    if @scope.user
      eventData.user = @scope.user.username
    eventData.userId = localStorage.getItem "userId"
    @analytics.eventTrack "applyClick", eventData
    
    if localStorage.getItem "userId"
      resource = @Restangular.all "userapplies"
      resource.post
        user: localStorage.getItem "userId"
        job: job._id
      .then =>
        job.$$applied = true
        # console.log ""
      , @errHandler
    
      
window.AppCommonJobCtrl = AppCommonJobCtrl
# angular.module('simplecareersApp').controller 'AppCommonJobCtrl', AppCommonJobCtrl
  

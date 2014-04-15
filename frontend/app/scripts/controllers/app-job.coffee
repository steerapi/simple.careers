'use strict'

class AppJobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader) ->
    super @scope
    @skip = @state.params.jobId
    @resource = @Restangular.all "jobs"
    @resource.getList(
      sort: "order"
      skip: @skip
      limit: 1
    ).then (jobs)=>      
      if jobs and jobs.length > 0
        @scope.job = jobs[0]
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
      @skip=0
      window.location.hash = "/app/#{@skip}"
    @scope.$on "noClick",=>
      @scope.status = "pass"
      @scope.swipeCard.setX -500
      @scope.swipeCard.transitionOut()
    @scope.$on "yesClick",=>
      @scope.status = "fav"
      @scope.swipeCard.setX 500
      @scope.swipeCard.transitionOut()
  cardDestroyed: (index)=>
    # @scope.jobs.splice(index, 1);
  cardSwipedLeft: (job)=>
    # console.log @scope.user,"left"
    @scope.user.favorites = _.without @scope.user.favorites, @scope.job._id
    @scope.update @scope.user,'favorites'
  cardSwipedRight: (job)=>
    # console.log @scope.user,"right"
    @scope.user.favorites?=[]
    @scope.user.favorites.push @scope.job._id
    @scope.update @scope.user,'favorites'
  cardDragStart: (job)=>
    # console.log "start drag"
  cardDragEnd: (job)=>
    # console.log "end drag"
    @dragging = false
  isValid: (job)=>
    return false if not job
    return job.position and job.companyname and job.logo and job.location and job.type and job.picture
  cardDrag: (x,y,job)=>
    @dragging = true
    # console.log "card drag"
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
      window.location.hash = "/app/#{@skip}"
    , 500
  flipClick: (job)=>
    # # console.log "flipClick"
    if not @applyClicked and not @dragging
      job.$$flip = not job.$$flip
    @applyClicked = false
  apply: (event)=>
    # # console.log "apply"
    event.preventDefault()
    @applyClicked = true
    # # console.log window.location.hash
    window.location.href = "/auth/linkedin?redirect=#{window.location.hash}"
    return
              
angular.module('simplecareersApp').controller 'AppJobCtrl', AppJobCtrl
  

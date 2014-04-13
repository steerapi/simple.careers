'use strict'

class AppJobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    console.log @state
    @skip = @state.params.jobId
    @resource = @Restangular.all "jobs"
    @resource.getList(
      sort: "order"
      skip: @skip
      limit: 1
    ).then (jobs)=>
      if jobs and jobs.length > 0
        @scope.desc = jobs[0].jobtagline
        jobs.splice 0,0,{}
        jobs.splice 0,0,{}
        @scope.jobs = jobs
    , =>
      @skip=0
      window.location.hash = "/app/#{@skip}"
  logout: =>
    localStorage.removeItem("userId");
  checkLogin: (cb)=>
    (cb?(@scope.user);return) if @scope.user
    userId = localStorage.getItem("userId");
    @resource = @Restangular.one "users", ""
    @resource.post({}).then (user)=>
      @scope.user = user
      cb?(@scope.user)
    return
  noClick:(job)=>
    return if not @checkLogin()
  yesClick:(job)=>
    return if not @checkLogin()
    
  cardDestroyed: (index)=>
    # @scope.jobs.splice(index, 1);
  cardSwipedLeft: (job)=>
    # console.log "Left"
  cardSwipedRight: (job)=>
    # console.log "Right"
  cardDrag: (x,y,job)=>
    if x<-50
      job.$$status = "left"
    else if x>50
      job.$$status = "right"
    # console.log "Drag", arguments...
  cardSwiped: (index)=>
    # @count++
    @timeout =>
      @skip++
      window.location.hash = "/app/#{@skip}"
    , 500
    # @resource = @Restangular.all "jobs"
    # @resource.getList(
    #   skip: @count
    #   limit: 1
    # ).then (jobs)=>
    #     
    # , =>
    #   @timeout =>
    #     @skip=0
    #     window.location.hash = "/app/#{@skip}"
    #   , 500  

  isValid: (job)=>
    return job.position and job.companyname and job.logo and job.location and job.type and job.picture
  flipClick: (job)=>
    # console.log "flipClick"
    if not @applyClicked 
      job.$$flip = not job.$$flip
    @applyClicked = false
  apply: (event)=>
    # console.log "apply"
    event.preventDefault()
    @applyClicked = true
    return
    
angular.module('simplecareersApp').controller 'AppJobCtrl', AppJobCtrl
  

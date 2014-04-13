'use strict'

class AppJobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @skip = @state.params.jobId
    @resource = @Restangular.all "jobs"
    @resource.getList(
      sort: "order"
      skip: @skip
      limit: 1
    ).then (jobs)=>
      if jobs and jobs.length > 0
        jobs.splice 0,0,{}
        jobs.splice 0,0,{}
        @scope.jobs = jobs
    , =>
      @skip=0
      window.location.hash = "/app/#{@skip}"
  cardDestroyed: (index)=>
    # @scope.jobs.splice(index, 1);
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
  

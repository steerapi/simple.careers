'use strict'

class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @scope.swipeCard = undefined
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
  noClick:=>
    @scope.$broadcast "noClick"
    # return if not @checkLogin()
  yesClick:=>
    @scope.$broadcast "yesClick"
    # return if not @checkLogin()

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


    # @init()
      
  # init: =>
    # console.log "init"
    # @count = 0
    # @resource = @Restangular.all "jobs"
    # @resource.getList(
    #   skip: @count
    #   limit: 1
    # ).then (jobs)=>
    #   @scope.jobs = jobs
    #   @scope.job = jobs[0]
    # @scope.flip = false
  # cardDestroyed: (index)=>
    # @scope.jobs.splice(index, 1);
  # cardSwiped: (index)=>
    # @count++
#     @resource = @Restangular.all "jobs"
#     @resource.getList(
#       skip: @count
#       limit: 1
#     ).then (jobs)=>
#       if jobs and jobs.length > 0
#         @scope.jobs.push(jobs[0]);
#     , =>
#       if @count>0
#         @timeout =>
#           @init()
#         , 500  
#       else
#         @scope.nomore = true

  # isValid: (job)=>
    # return job.position
    
angular.module('simplecareersApp').controller('AppCtrl', AppCtrl)

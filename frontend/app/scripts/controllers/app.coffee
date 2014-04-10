'use strict'

class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @init()
  init: =>
    # console.log "init"
    @count = 0
    @resource = @Restangular.all "jobs"
    @resource.getList(
      skip: @count
      limit: 1
    ).then (jobs)=>
      @scope.jobs = jobs
  cardDestroyed: (index)=>
    @scope.jobs.splice(index, 1);
  cardSwiped: (index)=>
    @count++
    @resource = @Restangular.all "jobs"
    @resource.getList(
      skip: @count
      limit: 1
    ).then (jobs)=>
      if jobs and jobs.length > 0
        @scope.jobs.push(jobs[0]);
    , =>
      if @count>0
        @timeout =>
          @init()
        , 500  
      else
        @scope.nomore = true
  flipClick: =>
    # console.log "flipClick"
    if not @applyClicked 
      @scope.flip = not @scope.flip
    @applyClicked = false
  apply: (event)=>
    # console.log "apply"
    event.preventDefault()
    @applyClicked = true
    return
    
angular.module('simplecareersApp').controller('AppCtrl', AppCtrl)

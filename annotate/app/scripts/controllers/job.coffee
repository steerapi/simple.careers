'use strict'

class JobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @scope.mode = "desc"
    @scope.$on "changeMode", (e,mode)=>
      @scope.mode = mode
    @scope.sortableOptions = {
      update: (e, ui)=>
        @timeout =>
          @scope.jobs?.forEach (item, idx)=>
            item.order = idx
            @save item
        return
    }
    @resource = @Restangular.all "jobs"
    @resource.getList(
      sort: "order"
    ).then (jobs)=>
      @scope.jobs = jobs
      if @state.params.jobId
        for job in @scope.jobs
          @scope.job = job if job._id == @state.params.jobId
          
    @scope.job = null
  newJob: =>
    @scope.jobs?=[]
    job = 
      order: @scope.jobs.length
    @resource.post(job).then (job)=>
      @scope.jobs.push job
  removeJob: (cjob,$event)=>
    $event.stopPropagation()
    for job,i in @scope.jobs
      if job and cjob and cjob._id == job._id
        @scope.jobs.splice i,1
        cjob.remove()
        break
    return
  changeJob: (job)=>
    @scope.job = job
    @state.go "job.item.#{@scope.mode}", jobId:job._id
    return
    
angular.module('simpleannotateApp').controller('JobCtrl', JobCtrl)

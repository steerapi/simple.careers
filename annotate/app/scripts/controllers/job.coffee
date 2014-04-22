'use strict'

class JobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @scope.mode = "desc"
    @scope.$on "changeMode", (e,mode)=>
      @scope.mode = mode
    @Restangular.setDefaultHeaders
      "Authorization": "Bearer 710882c2d16bb36d6b51505038fcd9eb"
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
  removeJob: (cjob)=>
    for job,i in @scope.jobs?
      if cjob and job and cjob._id == job._id
        @scope.jobs.splice i,1
        cjob.remove()
  changeJob: (job)=>
    @scope.job = job
    @state.go "job.item.#{@scope.mode}", jobId:job._id
    return
    
angular.module('simpleannotateApp').controller('JobCtrl', JobCtrl)

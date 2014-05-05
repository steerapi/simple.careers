'use strict'

class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @resource = @Restangular.all "jobs"
    @resource.getList(
      sort: "order"
    ).then (jobs)=>
      jobs.forEach (job)=>
        @resource = @Restangular.all "userapplies"
        @resource.getList
          conditions:
            job: job._id
          populate: "user job"
        .then (userapplies)=>
          @scope.userapplies = @scope.userapplies.concat userapplies
    @scope.userapplies = []
  update: (userapply,key)=>
    resource = @Restangular.one "userapplies",userapply._id
    resource[key] = userapply[key]
    resource.put()
    
angular.module('simpleannotateApp').controller('AppCtrl', AppCtrl)

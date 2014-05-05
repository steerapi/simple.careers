'use strict'

class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @resource = @Restangular.all "jobs"
    @resource.getList(
      sort: "order"
    ).then (jobs)=>
      async.eachSeries jobs,(job,cb)=>
        @resource = @Restangular.all "userapplies"
        @resource.getList
          conditions:
            job: job._id
          populate: "user job"
        .then (userapplies)=>
          @scope.userapplies = @scope.userapplies.concat userapplies
          cb()
        , =>
          cb()
    @scope.userapplies = []
  update: (userapply,key)=>
    resource = @Restangular.one "userapplies",userapply._id
    resource[key] = userapply[key]
    resource.put()
  removeApp: (userapply,index)=>
    resource = @Restangular.all "userapplies"
    resource.remove
      conditions:
        _id: userapply._id
    .then (userapply)=>
      @scope.userapplies.splice index,1
      return
    
angular.module('simpleannotateApp').controller('AppCtrl', AppCtrl)

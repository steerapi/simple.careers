'use strict'

class JobAppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @scope.$state = @state
    @scope.$stateParams = @stateParams
    @wait @scope, 'job', =>
      @resource = @Restangular.all "userapplies"
      @resource.getList
        conditions:
          job: @scope.job._id
        populate: "user"
      .then (userapplies)=>
        @scope.userapplies = userapplies
  removeApp: (userapply,index)=>
    @resource.remove
      conditions:
        _id: userapply._id
    .then (userapply)=>
      @scope.userapplies.splice index,1
      return

angular.module('simpleannotateApp').controller('JobAppCtrl', JobAppCtrl)

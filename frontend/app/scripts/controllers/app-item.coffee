'use strict'

class AppItemCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    # # console.log "@state.params.jobId", @state.params.jobId
    # if not @state.params.jobId
    #   @resource = @Restangular.all("jobs")
    #   @resource.getList(
    #     limit:1
    #   ).then (jobs)=>
    #     job = jobs[0]
    #     window.location.hash = "#/app/all/#{job._id}"
    # @filter = {}
    # @scope.limit = 5
    # @scope.page = 0
    # @pagingKey = "jobs"
    # @pagingFn = (cb)=>
    #   @resource = @Restangular.all("jobs")
    #   @resource.getList(
    #     conditions: @filter
    #     limit: @scope.limit
    #     skip: @scope.page*@scope.limit
    #     sort: "order"
    #   ).then (items)=>
    #     cb(items)
    # @myPagingFunction()
    
    
angular.module('simplecareersApp').controller 'AppItemCtrl', AppItemCtrl
  

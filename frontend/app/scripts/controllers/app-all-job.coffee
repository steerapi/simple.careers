'use strict'

class AppAllJobCtrl extends AppCommonJobCtrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader","$analytics"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics) ->
    super @scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics
    @type = "all"
    @scope.$emit "setEnableShare", true
    localStorage.setItem "page", @state.params.jobId
    @init()
  newQuery: (sk)=>
    query = super sk
    return query

angular.module('simplecareersApp').controller 'AppAllJobCtrl', AppAllJobCtrl
  

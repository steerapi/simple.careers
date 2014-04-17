'use strict'

class AppAllJobCtrl extends AppCommonJobCtrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader","$analytics"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics) ->
    super @scope, @stateParams, @state, @Restangular, @timeout, @preloader,@analytics
    @type = "all"
    @scope.$emit "setEnableShare", true
    localStorage.setItem "page", @state.params.jobId
    @timeout =>
      if not localStorage.getItem("visited")
        @state.go "intro.page", pageId:0
      @init()
  newQuery: (sk)=>
    query = super sk
    return query

angular.module('simplecareersApp').controller 'AppAllJobCtrl', AppAllJobCtrl
  

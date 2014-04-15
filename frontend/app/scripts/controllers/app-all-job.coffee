'use strict'

class AppAllJobCtrl extends AppCommonJobCtrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout", "preloader"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout, @preloader) ->
    super @scope, @stateParams, @state, @Restangular, @timeout, @preloader
    @type = "all"
    @scope.$emit "setEnableShare", true
    @init()
  newQuery: (sk)=>
    query = super sk
    return query

angular.module('simplecareersApp').controller 'AppAllJobCtrl', AppAllJobCtrl
  

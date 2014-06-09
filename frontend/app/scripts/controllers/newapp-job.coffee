'use strict'

class NewAppJobCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    

angular.module('simplecareersApp').controller('NewAppJobCtrl', NewAppJobCtrl)

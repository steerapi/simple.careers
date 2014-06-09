'use strict'

class NewAppApplyCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    

angular.module('simplecareersApp').controller('NewAppApplyCtrl', NewAppApplyCtrl)

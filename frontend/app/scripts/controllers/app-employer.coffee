'use strict'

class AppEmployerCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    
angular.module('simplecareersApp').controller 'AppEmployerCtrl', AppEmployerCtrl
  

'use strict'

class IntroCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    
angular.module('simplecareersApp').controller 'IntroCtrl', IntroCtrl
  

'use strict'

class IntroCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    console.log @state
    console.log @stateParams
    super @scope
    
angular.module('simplecareersApp').controller 'IntroCtrl', IntroCtrl
  

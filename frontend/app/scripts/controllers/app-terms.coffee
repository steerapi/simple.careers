'use strict'

class AppTermsCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
  back:=>
    window.history.back();
    
    
angular.module('simplecareersApp').controller 'AppTermsCtrl', AppTermsCtrl
  

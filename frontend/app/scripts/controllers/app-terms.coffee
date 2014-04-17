'use strict'

class AppTermsCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
  back:=>
    @state.go "intro.page", pageId:2
    
    
angular.module('simplecareersApp').controller 'AppTermsCtrl', AppTermsCtrl
  

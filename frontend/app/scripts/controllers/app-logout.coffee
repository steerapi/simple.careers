'use strict'

class AppLogoutCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    localStorage.removeItem "userId", @stateParams.userId
    localStorage.removeItem "token", @stateParams.token
    window.location.href = "/app/all/0"
    
angular.module('simplecareersApp').controller 'AppLogoutCtrl', AppLogoutCtrl
  

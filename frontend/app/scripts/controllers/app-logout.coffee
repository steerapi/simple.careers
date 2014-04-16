'use strict'

class AppLogoutCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    localStorage.removeItem "userId", @stateParams.userId
    localStorage.removeItem "token", @stateParams.token
    @state.go "app.all.job", jobId:0
    
angular.module('simplecareersApp').controller 'AppLogoutCtrl', AppLogoutCtrl
  

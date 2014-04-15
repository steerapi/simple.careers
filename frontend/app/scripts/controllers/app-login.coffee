'use strict'

class AppLoginCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    # console.log @stateParams.userId
    # console.log @stateParams.token
    # console.log @stateParams.redirect
    localStorage.setItem "userId", @stateParams.userId
    localStorage.setItem "token", @stateParams.token
    # @Restangular.setDefaultHeaders
    #   "Authorization": "Bearer #{@stateParams.token}"
    # window.location.href = @stateParams.redirect
    
angular.module('simplecareersApp').controller 'AppLoginCtrl', AppLoginCtrl


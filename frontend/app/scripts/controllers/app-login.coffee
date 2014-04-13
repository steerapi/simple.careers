'use strict'

class AppLoginCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    # console.log @state
    # console.log @stateParams
    localStorage.setItem "userId", @stateParams.userId
    # console.log @Restangular.setDefaultHeaders
    @Restangular.setDefaultHeaders
      "Authorization": "Bearer #{@stateParams.token}"
    @resource = @Restangular.one "users", localStorage.getItem "userId"
    @resource.get().then (user)=>
      console.log "user", user
    super @scope
    
angular.module('simplecareersApp').controller 'AppLoginCtrl', AppLoginCtrl
  

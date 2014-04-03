'use strict'

angular.module('simplecareersApp')
  .controller 'MainCtrl', ($scope) ->
    console.log "Hi"
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
  .controller("DashCtrl", ($scope) ->
  ).controller("FriendsCtrl", ($scope) ->
    # $scope.friends = Friends.all()
    return
  ).controller("FriendDetailCtrl", ($scope, $stateParams) ->
    # $scope.friend = Friends.get($stateParams.friendId)
    return
  ).controller "AccountCtrl", ($scope) ->

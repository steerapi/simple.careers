'use strict'

class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    
angular.module('simplecareersApp').controller('AppCtrl', AppCtrl)
.controller "ContentController", ($scope, $location,$ionicSideMenuDelegate) ->
  $scope.toggleLeft = =>
    $ionicSideMenuDelegate.toggleLeft();
  $scope.items = [
    {
      id: 1
      title: "Leagues"
    }
    {
      id: 2
      title: "Share"
    }
    {
      id: 3
      title: "Feedback"
    }
  ]
  $scope.selectNavItem = (item, $index) ->
    if $index is 0
      $location.path "/"
      $scope.sideMenuController.close()
    else if $index is 2
      $location.path "/feedback"
      $scope.sideMenuController.close()
    else
      $location.path "/friends"
      $scope.sideMenuController.close()
    return

  return
  

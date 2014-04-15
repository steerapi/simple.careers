'use strict'

describe 'Controller: AppFavoriteJobCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppFavoriteJobCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppFavoriteJobCtrl = $controller 'AppFavoriteJobCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

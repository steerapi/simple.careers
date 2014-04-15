'use strict'

describe 'Controller: AppAllJobCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppAllJobCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppAllJobCtrl = $controller 'AppAllJobCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

'use strict'

describe 'Controller: AppJobCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppJobCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppJobCtrl = $controller 'AppJobCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

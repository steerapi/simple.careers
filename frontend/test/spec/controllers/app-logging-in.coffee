'use strict'

describe 'Controller: AppLoggingInCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppLoggingInCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppLoggingInCtrl = $controller 'AppLoggingInCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

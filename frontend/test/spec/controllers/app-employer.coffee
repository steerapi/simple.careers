'use strict'

describe 'Controller: AppEmployerCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppEmployerCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppEmployerCtrl = $controller 'AppEmployerCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

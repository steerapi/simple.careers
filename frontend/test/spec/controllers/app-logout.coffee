'use strict'

describe 'Controller: AppLogoutCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppLogoutCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppLogoutCtrl = $controller 'AppLogoutCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

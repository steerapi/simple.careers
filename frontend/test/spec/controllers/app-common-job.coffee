'use strict'

describe 'Controller: AppCommonJobCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppCommonJobCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppCommonJobCtrl = $controller 'AppCommonJobCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

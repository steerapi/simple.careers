'use strict'

describe 'Controller: AppItemCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppItemCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppItemCtrl = $controller 'AppItemCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

'use strict'

describe 'Controller: AppLoginCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppLoginCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppLoginCtrl = $controller 'AppLoginCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

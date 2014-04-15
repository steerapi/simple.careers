'use strict'

describe 'Controller: AppApplyJobCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppApplyJobCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppApplyJobCtrl = $controller 'AppApplyJobCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

'use strict'

describe 'Controller: IntroPageCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  IntroPageCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    IntroPageCtrl = $controller 'IntroPageCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

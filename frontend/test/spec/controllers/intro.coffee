'use strict'

describe 'Controller: IntroCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  IntroCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    IntroCtrl = $controller 'IntroCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

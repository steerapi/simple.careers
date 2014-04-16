'use strict'

describe 'Controller: AppTermsCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppTermsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppTermsCtrl = $controller 'AppTermsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

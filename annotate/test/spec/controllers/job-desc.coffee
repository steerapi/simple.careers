'use strict'

describe 'Controller: JobDescCtrl', ->

  # load the controller's module
  beforeEach module 'simpleannotateApp'

  JobDescCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    JobDescCtrl = $controller 'JobDescCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

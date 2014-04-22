'use strict'

describe 'Controller: JobCtrl', ->

  # load the controller's module
  beforeEach module 'simpleannotateApp'

  JobCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    JobCtrl = $controller 'JobCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

'use strict'

describe 'Controller: JobItemCtrl', ->

  # load the controller's module
  beforeEach module 'simpleannotateApp'

  JobItemCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    JobItemCtrl = $controller 'JobItemCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

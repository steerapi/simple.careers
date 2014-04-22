'use strict'

describe 'Controller: JobAppCtrl', ->

  # load the controller's module
  beforeEach module 'simpleannotateApp'

  JobAppCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    JobAppCtrl = $controller 'JobAppCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

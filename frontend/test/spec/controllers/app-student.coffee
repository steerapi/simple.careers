'use strict'

describe 'Controller: AppStudentCtrl', ->

  # load the controller's module
  beforeEach module 'simplecareersApp'

  AppStudentCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AppStudentCtrl = $controller 'AppStudentCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3

'use strict'

class Ctrl
  @$inject: ['$scope']
  constructor: (@scope) ->
    for k in _.functions @
      @scope[k] = @[k] if k!="constructor"
    @scope.save = _.debounce @scope.save, 1000
  update: (resource, key)=>
    @scope.$emit "notification", 
      message: "updating..."
    updateResource = @Restangular.one resource.route, resource._id
    updateResource[key] = resource[key]
    updateResource.put().then =>
      @scope.$emit "notification", 
        message: "done"
  save: (resource,cb=->)=>
    @scope.$emit "notification", 
      message: "updating..."
    resource.put().then =>
      cb()
      @scope.$emit "notification", 
        message: "done"
  wait: (scope,key,cb)=>
    if not scope[key]
      listener = scope.$watch key, (value)=>
        if value
          cb()
          listener()
    else
      cb()

window.Ctrl = Ctrl
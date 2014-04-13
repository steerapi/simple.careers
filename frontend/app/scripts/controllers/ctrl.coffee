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
  convert: (file)=>
    return if not file
    url = file.url
    return url if /gif/.test file.mimetype
    if /filepicker/.test url
      return "#{url}/convert?w=600&h=450"
    return url
window.Ctrl = Ctrl
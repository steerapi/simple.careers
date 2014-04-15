'use strict'

jobCache = {}

class Ctrl
  @$inject: ['$scope']    
  constructor: (@scope) ->
    for k in _.functions @
      @scope[k] = @[k] if k!="constructor"
    @scope.save = _.debounce @scope.save, 1000
  checkLogin: ($scope,$Restangular,cb)=>
    userId = localStorage.getItem("userId");
    token = localStorage.getItem("token");
    # # console.log "check",userId,token
    if (not userId) or (not token)
      # console.log "change location","/auth/linkedin?redirect=#{window.location.hash.replace('#','')}"
      window.location.href = "/auth/linkedin?redirect=#{window.location.hash.replace('#','')}"
      return
    # # console.log "check"
    (cb?($scope.user);return) if $scope.user
    $Restangular.setDefaultHeaders
      "Authorization": "Bearer #{localStorage.getItem "token"}"
    resource = $Restangular.one "users", localStorage.getItem "userId"
    resource.get().then (user)=>
      $scope.user = user
      cb?(user)

  purgeJobCache:=>
    jobCache = {}
  jobRequest:(Restangular, preloadImages, query, cb, ecb)=>
    k = JSON.stringify(query)
    job = jobCache[k]
    if job
      # purge cache
      delete jobCache[k]
      cb? [job]
      return
    resource = Restangular.all("jobs")
    resource.getList( query ).then (jobs)=>
      if jobs and jobs.length > 0
        job = jobs[0]
        jobCache[k] = job
        preloadImages?([job.picture?.url]).then =>
      cb? jobs
    , =>
      ecb? arguments...
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
  wait: (scope,key,cb)=>
    # # console.log "scope[key]", scope[key], key
    if not scope[key]
      listener = scope.$watch key, =>
        if scope[key]
          cb()
          listener()
    else
      cb()

  myPagingFunction: =>
    if @scope.pagingBusy or @scope.pagingDone
      return
    if not @filter
      return
    @scope.pagingBusy = true
    @pagingFn? (items)=>
      if items.length > 0
        @scope[@pagingKey] = if @scope[@pagingKey] then @scope[@pagingKey].concat items else items
      else
        @scope.pagingDone = true
      @scope.page++
      @scope.pagingBusy = false

window.Ctrl = Ctrl
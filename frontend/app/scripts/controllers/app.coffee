'use strict'

window.myMenu = undefined
class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    if window.eventListener
      document.removeEventListener "touchmove", window.eventListener
      document.addEventListener "touchmove", window.eventListener = (e) ->
        e.preventDefault()
      return
    @timeout =>
      # console.log "AppCtrl", window.myMenu
      window.myMenu = myMenu = new PathMenu(
        bezierCurve:
          x0: 40
          y0: 182
          x1: 85
          y1: 190
          x2: 78
          y2: 100
          x3: 70
        elem: document.getElementById("menu")
        items: [
          {
            url: "/app/all/" + localStorage.getItem("page")
            backgroundUrl: "/images/menu/menu-all.png"
            title: "All"
          }
          {
            url: "/app/apply/0"
            backgroundUrl: "/images/menu/menu-apply.png"
            title: "Apply"
          }
          {
            url: "/app/favorite/0"
            backgroundUrl: "/images/menu/menu-favorite.png"
            title: "Favorite"
          }
          {
            url: "/app/logout"
            backgroundUrl: "/images/menu/menu-logout.png"
            title: "Logout"
          }
        ]
        mainButton:
          backgroundUrl: "/images/menu/menu-menu.png"
          backButtonBackgroundUrl: "/images/menu/menu-menu.png"

        expandPattern: PathMenu.ExpandPattern.rightTopFixedArc
      )

    @scope.$state = @state
    @scope.url = undefined
    @scope.$on "shareUrl", (event, url)=>
      @scope.url = url
    @scope.$on "setEnableShare", (event, enable)=>
      @scope.enableShare = enable
  noClick:=>
    # @checkLogin @Restangular, (user)=>
      # # console.log "pass"
      # @scope.user = user
    @scope.$broadcast "noClick"
  yesClick:=>
    # @checkLogin @Restangular, (user)=>
      # # console.log "pass"
      # @scope.user = user
    @scope.$broadcast "yesClick"

    # @resource = @Restangular.all "jobs"
    # @resource.getList(
    #   skip: @count
    #   limit: 1
    # ).then (jobs)=>
    #     
    # , =>
    #   @timeout =>
    #     @skip=0
    #     window.location.hash = "/app/#{@skip}"
    #   , 500  


    # @init()
      
  # init: =>
    # # console.log "init"
    # @count = 0
    # @resource = @Restangular.all "jobs"
    # @resource.getList(
    #   skip: @count
    #   limit: 1
    # ).then (jobs)=>
    #   @scope.jobs = jobs
    #   @scope.job = jobs[0]
    # @scope.flip = false
  # cardDestroyed: (index)=>
    # @scope.jobs.splice(index, 1);
  # cardSwiped: (index)=>
    # @count++
#     @resource = @Restangular.all "jobs"
#     @resource.getList(
#       skip: @count
#       limit: 1
#     ).then (jobs)=>
#       if jobs and jobs.length > 0
#         @scope.jobs.push(jobs[0]);
#     , =>
#       if @count>0
#         @timeout =>
#           @init()
#         , 500  
#       else
#         @scope.nomore = true

  # isValid: (job)=>
    # return job.position
    
angular.module('simplecareersApp').controller('AppCtrl', AppCtrl)

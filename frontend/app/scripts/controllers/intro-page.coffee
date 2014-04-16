'use strict'

class IntroPageCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', '$ionicSlideBoxDelegate', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @ionicSlideBoxDelegate, @Restangular, @timeout) ->
    super @scope
    @scope.slideIndex = @stateParams.pageId or 0
    if localStorage.getItem("visited")
      page = localStorage.getItem("page") or 0
      @state.go "app.all.job", jobId:page
  startApp: =>
    localStorage.setItem "visited", true
    page = localStorage.getItem("page") or 0
    @state.go "app.all.job", jobId:page
    return
  next:=>
    @ionicSlideBoxDelegate.next()
    return
  previous: =>
    @ionicSlideBoxDelegate.previous()
    return
  slideChanged: (index) =>
    @scope.slideIndex = index
    @timeout =>
      @state.go "intro.page", pageId:index
    , 100
    return
  terms:=>
    @state.go "terms"

angular.module('simplecareersApp')
  .controller 'IntroPageCtrl', IntroPageCtrl
  
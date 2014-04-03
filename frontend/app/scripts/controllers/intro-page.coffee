'use strict'

class IntroPageCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', '$ionicSlideBoxDelegate', "Restangular"]
  constructor: (@scope, @stateParams, @state, @ionicSlideBoxDelegate, @Restangular) ->
    super @scope
  startApp: =>
    @state.go "app"
    return
  next:=>
    @ionicSlideBoxDelegate.next()
    return
  previous: =>
    @ionicSlideBoxDelegate.previous()
    return
  slideChanged: (index) =>
    @scope.slideIndex = index
    return

angular.module('simplecareersApp')
  .controller 'IntroPageCtrl', IntroPageCtrl
  
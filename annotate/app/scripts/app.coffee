'use strict'

filepicker.setKey "A7hqLKRidRZIvOwJrVOLpz"

angular
  .module('simpleannotateApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ui.router',
    # 'ngRoute',
    'ui.sortable',
    'restangular',
    'videosharing-embed'
  ])
  .config([
    'RestangularProvider'
  	'$stateProvider'
    '$urlRouterProvider'
  	(RestangularProvider, $stateProvider, $urlRouterProvider, config) ->
      RestangularProvider.setRestangularFields
        id: "_id"
      RestangularProvider.setBaseUrl "/api/data/"
      RestangularProvider.setDefaultHeaders
        "Authorization": "Bearer 5168fb941960bec6afaa7b23f2d0fa92"
      
      $urlRouterProvider.otherwise "/job"
      $stateProvider
      .state('app',
        url: "/app",
        views: 
          {
            'view': {
              templateUrl: "./views/app.html",
              controller: "AppCtrl"
            }
          }
      )
      .state('job',
        url: "/job",
        views: 
          {
            'view': {
              templateUrl: "./views/job.html",
              controller: "JobCtrl"
            }
          }
      )
      .state('job.item',
        url: "/:jobId",
        views: 
          {
            'view.view': {
              templateUrl: "./views/job-item.html",
              controller: "JobItemCtrl"
            }
          }
      )
      .state('job.item.desc',
        url: "/desc",
        views: 
          {
            'view.view.view': {
              templateUrl: "./views/job-desc.html",
              controller: "JobDescCtrl"
            }
          }
      )
      .state('job.item.app',
        url: "/app",
        views: 
          {
            'view.view.view': {
              templateUrl: "./views/job-app.html",
              controller: "JobAppCtrl"
            }
          }
      )
  ])
  .directive "imgCropped", ->
    # restrict: "A"
    replace: true
    scope:
      src: "@"
      crop: "="
      selected: "&"

    link: (scope, element, attr) ->
      myImg = undefined
      clear = ->
        if myImg
          myImg.next().remove()
          myImg.remove()
          myImg = `undefined`
        return

      scope.$watch "src", (nv) ->
        clear()
        if nv
          scope.crop?=
            x:0
            y:0
            x2:300
            y2:225
          element.after "<img />"
          myImg = element.next()
          myImg.attr "src", nv
          temp = new Image()
          temp.src = nv
          temp.onload = ->
            width = @width
            height = @height
            $(myImg).Jcrop
              trackDocument: true
              onSelect: (x) ->
                scope.selected cords: x
                return

              aspectRatio: 4/3
              boxWidth: 400
              boxHeight: 400
              setSelect: [
                scope.crop.x
                scope.crop.y
                scope.crop.x2
                scope.crop.y2
              ]
              trueSize: [
                width
                height
              ]

            return
        return

      scope.$on "$destroy", clear
      return
  

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
    'restangular'
  ])
  .config([
    'RestangularProvider'
  	'$stateProvider'
    '$urlRouterProvider'
  	(RestangularProvider, $stateProvider, $urlRouterProvider, config) ->
      RestangularProvider.setRestangularFields
        id: "_id"
      RestangularProvider.setBaseUrl "/api/data/"
        
      $urlRouterProvider.otherwise "/job"
      $stateProvider
      .state('job',
        url: "/job",
        views: 
          {
            'view': {
              templateUrl: "/views/job.html",
              controller: "JobCtrl"
            }
          }
      )
      .state('job.item',
        url: "/:jobId",
        views: 
          {
            'view.view': {
              templateUrl: "/views/job-item.html",
              controller: "JobItemCtrl"
            }
          }
      )
      .state('job.item.desc',
        url: "/desc",
        views: 
          {
            'view.view.view': {
              templateUrl: "/views/job-desc.html",
              controller: "JobDescCtrl"
            }
          }
      )
      .state('job.item.app',
        url: "/app",
        views: 
          {
            'view.view.view': {
              templateUrl: "/views/job-app.html",
              controller: "JobAppCtrl"
            }
          }
      )
  ])

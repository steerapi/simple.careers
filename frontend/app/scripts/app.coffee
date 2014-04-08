'use strict'

angular
  .module('simplecareersApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    # 'ngRoute',
    # 'ui.router',
    'ionic',
    'restangular'
  ])
  .config([
    'RestangularProvider'
  	'$stateProvider'
    '$urlRouterProvider'
  	(RestangularProvider, $stateProvider, $urlRouterProvider, config) ->
      RestangularProvider.setRestangularFields
        id: "_id"
      RestangularProvider.setBaseUrl "http://mobile.fairsey.com/data/v1/"
        
      $urlRouterProvider.otherwise "/intro/page"
      $stateProvider
      .state('intro',
        url: "/intro",
        views: 
          {
            'main': {
              templateUrl: "/views/intro/intro.html",
              controller: "IntroCtrl"
            }
          }
      )
      .state('intro.page',
        url: "/page",
        views: 
          {
            'main.intro': {
              templateUrl: "/views/intro/intro-page.html",
              controller: "IntroPageCtrl"
            }
          }
      )
      .state('app',
        url: "/app",
        views: 
          {
            'main': {
              templateUrl: "/views/app/app.html",
              controller: "AppCtrl"
            }
          }
      )
      # .state('app.job',
      #   url: "/job",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
      # .state('app.profile',
      #   url: "/profile",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
      # .state('app.applied',
      #   url: "/applied",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
      # .state('app.inbox',
      #   url: "/inbox",
      #   views: 
      #     {
      #       'main.app': {
      #         templateUrl: "/views/app/job.html",
      #         controller: "AppJobCtrl"
      #       }
      #     }
      # )
  ])

    # $stateProvider.state("tab",
    #   url: "/tab"
    #   abstract: true
    #   templateUrl: "views/tabs.html"
    # ).state("tab.dash",
    #   url: "/dash"
    #   views:
    #     "tab-dash":
    #       templateUrl: "views/tab-dash.html"
    #       controller: "DashCtrl"
    # ).state("tab.friends",
    #   url: "/friends"
    #   views:
    #     "tab-friends":
    #       templateUrl: "views/tab-friends.html"
    #       controller: "FriendsCtrl"
    # ).state("tab.friend-detail",
    #   url: "/friend/:friendId"
    #   views:
    #     "tab-friends":
    #       templateUrl: "views/friend-detail.html"
    #       controller: "FriendDetailCtrl"
    # ).state "tab.account",
    #   url: "/account"
    #   views:
    #     "tab-account":
    #       templateUrl: "views/tab-account.html"
    #       controller: "AccountCtrl"
    # 
    # $urlRouterProvider.otherwise "/tab/dash"
    # 
    # $urlRouterProvider.otherwise "/"
    # $stateProvider.state "index",
    #   url: "/"
    #   templateUrl: "views/main.html"
    #   controller: "MainCtrl"

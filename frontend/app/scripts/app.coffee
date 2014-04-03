'use strict'

angular
  .module('simplecareersApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    # 'ngRoute',
    # 'ui.router',
    'ionic'
  ])
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise "/intro"
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

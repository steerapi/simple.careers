(function(){"use strict";angular.module("simplecareersApp",["ngCookies","ngResource","ngSanitize","ionic"]).config(["$stateProvider","$urlRouterProvider",function(a,b){return b.otherwise("/intro"),a.state("intro",{url:"/intro",views:{main:{templateUrl:"/views/intro/intro.html",controller:"IntroCtrl"}}}).state("intro.page",{url:"/page",views:{"main.intro":{templateUrl:"/views/intro/intro-page.html",controller:"IntroPageCtrl"}}})}])}).call(this),function(){"use strict";angular.module("simplecareersApp").controller("MainCtrl",["$scope",function(a){return console.log("Hi"),a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma"]}]).controller("DashCtrl",["$scope",function(){}]).controller("FriendsCtrl",["$scope",function(){}]).controller("FriendDetailCtrl",["$scope","$stateParams",function(){}]).controller("AccountCtrl",["$scope",function(){}])}.call(this),function(){"use strict";angular.module("simplecareersApp").controller("UserCtrl",["$scope",function(a){return a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma"]}])}.call(this),function(){"use strict";angular.module("simplecareersApp").controller("IntroCtrl",["$scope","$location",function(a){return a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma"]}])}.call(this),function(){"use strict";angular.module("simplecareersApp").controller("IntroPageCtrl",["$scope","$location",function(a,b){var c,d,e;return e=function(){b.path("/main"),window.localStorage.didTutorial=!0},"true"===window.localStorage.didTutorial?void e():(a.next=function(){a.$broadcast("slideBox.nextSlide")},d=[{content:"Next",type:"button-positive button-clear",tap:function(){a.next()}}],c=[{content:"Skip",type:"button-positive button-clear",tap:function(){e()}}],a.leftButtons=c,a.rightButtons=d,void(a.slideChanged=function(b){a.leftButtons=b>0?[{content:"Back",type:"button-positive button-clear",tap:function(){a.$broadcast("slideBox.prevSlide")}}]:c,a.rightButtons=2===b?[{content:"Start using MyApp",type:"button-positive button-clear",tap:function(){e()}}]:d}))}])}.call(this);
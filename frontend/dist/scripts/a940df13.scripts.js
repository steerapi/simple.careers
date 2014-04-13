(function(){"use strict";!function(){var a,b,c;for(a=0,b=["webkit","moz"],c=0;c<b.length&&!window.requestAnimationFrame;)window.requestAnimationFrame=window[b[c]+"RequestAnimationFrame"],window.cancelAnimationFrame=window[b[c]+"CancelAnimationFrame"]||window[b[c]+"CancelRequestAnimationFrame"],++c;window.requestAnimationFrame||(window.requestAnimationFrame=function(b){var c,d,e;return c=(new Date).getTime(),e=Math.max(0,16-(c-a)),d=window.setTimeout(function(){b(c+e)},e),a=c+e,d}),window.cancelAnimationFrame||(window.cancelAnimationFrame=function(a){clearTimeout(a)})}(),window.rAF=window.requestAnimationFrame,function(a){var b,c,d,e,f,g,h,i;for(f=document.createElement("div"),h=["webkitTransformOrigin","transform-origin","-webkit-transform-origin","webkit-transform-origin","-moz-transform-origin","moz-transform-origin","MozTransformOrigin","mozTransformOrigin"],d="webkitTransformOrigin",g=0;g<h.length;){if(void 0!==f.style[h[g]]){d=h[g];break}g++}for(i=["webkitTransition","transition","-webkit-transition","webkit-transition","-moz-transition","moz-transition","MozTransition","mozTransition"],e="webkitTransition",g=0;g<i.length;){if(void 0!==f.style[i[g]]){e=i[g];break}g++}b=a.controllers.ViewController.inherit({initialize:function(a){var b;this.cards=[],b=window.innerWidth/window.innerHeight,this.maxWidth=window.innerWidth-(a.cardGutterWidth||0),this.maxHeight=a.height||300,this.cardGutterWidth=a.cardGutterWidth||10,this.cardPopInDuration=a.cardPopInDuration||400,this.cardAnimation=a.cardAnimation||"pop-in"},pushCard:function(a){var b;b=this,this.cards.push(a),this.beforeCardShow(a),a.transitionIn(this.cardAnimation),setTimeout(function(){a.disableTransition(b.cardAnimation)},this.cardPopInDuration+100)},beforeCardShow:function(){var a,b,c;b=this.cards[this.cards.length-1],b&&(c=window.innerHeight/2-this.maxHeight/2,a=5*Math.min(this.cards.length,3),b.setY(b.y-a),b.setPopInDuration(this.cardPopInDuration),b.setZIndex(10*this.cards.length))},popCard:function(a){var b;return b=this.cards.pop(),a&&b.swipe(),b}}),c=a.views.View.inherit({initialize:function(b){b=a.extend({},b),a.extend(this,b),this.el=b.el,this.startX=this.startY=this.x=this.y=0,this.bindEvents()},setX:function(b){this.el.style[a.CSS.TRANSFORM]="translate3d("+b+"px,"+this.y+"px, 0)",this.x=b,this.startX=b},setY:function(b){this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px,"+b+"px, 0)",this.y=b,this.startY=b},setZIndex:function(a){this.el.style.zIndex=a},setWidth:function(a){this.el.style.width=a+"px"},setHeight:function(a){this.el.style.height=a+"px"},setPopInDuration:function(a){this.cardPopInDuration=a},transitionIn:function(a){var b;b=this,this.el.classList.add(a+"-start"),this.el.classList.add(a),this.el.style.display="block",setTimeout(function(){b.el.classList.remove(a+"-start")},100)},disableTransition:function(a){this.el.classList.remove(a)},swipe:function(){this.transitionOut()},transitionOut:function(){var b,c,d;d=this,this.x>-50&&this.x<50?(this.el.style[e]="-webkit-transform 0.2s ease-in-out",this.el.style[a.CSS.TRANSFORM]="translate3d("+this.startX+"px,"+this.startY+"px, 0)",setTimeout(function(){d.el.style[e]="none"},200)):(c=this.rotationAngle+.6*this.rotationDirection||.4*Math.random(),b=this.rotationAngle?.3:.5,this.el.style[e]="-webkit-transform "+b+"s ease-in-out",this.x<-50?(this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px,"+3*window.innerHeight+"px, 0) rotate("+c+"rad)",this.onSwipeLeft&&this.onSwipeLeft()):(this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px,"+3*window.innerHeight+"px, 0) rotate("+c+"rad)",this.onSwipeRight&&this.onSwipeRight()),this.onSwipe&&this.onSwipe(),setTimeout(function(){d.onDestroy&&d.onDestroy()},1e3*b))},bindEvents:function(){var b;b=this,a.onGesture("dragstart",function(a){var c;a.preventDefault(),c=window.innerWidth/2,a.gesture.touches[0].pageX<c?b._transformOriginRight():b._transformOriginLeft(),window.rAF(function(){b._doDragStart(a)})},this.el),a.onGesture("drag",function(a){a.preventDefault(),window.rAF(function(){b._doDrag(a)})},this.el),a.onGesture("dragend",function(a){a.preventDefault(),window.rAF(function(){b._doDragEnd(a)})},this.el)},_transformOriginLeft:function(){this.el.style[d]="left center",this.rotationDirection=1},_transformOriginRight:function(){this.el.style[d]="right center",this.rotationDirection=-1},_doDragStart:function(a){var b,c,d;d=this.el.offsetWidth,c=window.innerWidth/2+this.rotationDirection*(d/2),b=Math.abs(c-a.gesture.touches[0].pageY),this.touchDistance=10*b},_doDrag:function(b){var c;c=b.gesture.deltaY/3,this.rotationAngle=Math.atan(c/this.touchDistance)*this.rotationDirection,b.gesture.deltaY<0&&(this.rotationAngle=0),this.x=this.startX+b.gesture.deltaX,this.y=this.startY+b.gesture.deltaY,this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px, "+this.y+"px, 0) rotate("+(this.rotationAngle||0)+"rad)",this.onDrag(this.x,this.y)},_doDragEnd:function(a){this.transitionOut(a)}}),angular.module("ionic.contrib.ui.cards",["ionic"]).directive("swipeCard",["$timeout",function(a){return{restrict:"E",template:'<div class="swipe-card" ng-transclude></div>',require:"^swipeCards",replace:!0,transclude:!0,scope:{onDrag:"&",onSwipeLeft:"&",onSwipeRight:"&",onSwipe:"&",onDestroy:"&"},compile:function(){return function(b,d,e,f){var g,h;g=d[0],h=new c({el:g,onDrag:function(c,d){a(function(){"function"==typeof b.onDrag&&b.onDrag({$x:c,$y:d})})},onSwipeRight:function(){a(function(){"function"==typeof b.onSwipeRight&&b.onSwipeRight()})},onSwipeLeft:function(){a(function(){"function"==typeof b.onSwipeLeft&&b.onSwipeLeft()})},onSwipe:function(){a(function(){"function"==typeof b.onSwipe&&b.onSwipe()})},onDestroy:function(){a(function(){"function"==typeof b.onDestroy&&b.onDestroy()})}}),b.$parent.swipeCard=h,f.pushCard(h)}}}}]).directive("swipeCards",["$rootScope",function(a){return{restrict:"E",template:'<div class="swipe-cards" ng-transclude></div>',replace:!0,transclude:!0,scope:{},controller:function(){var c;return c=new b({}),a.$on("swipeCard.pop",function(a){c.popCard(a)}),c}}}]).factory("$ionicSwipeCardDelegate",["$rootScope",function(a){return{popCard:function(b,c){a.$emit("swipeCard.pop",c)},getSwipebleCard:function(a){return a.$parent.swipeCard}}}])}(window.ionic),angular.module("simplecareersApp",["ngCookies","ngResource","ngSanitize","ngSocial","ionic","ionic.contrib.ui.cards","restangular"]).config(["$locationProvider","RestangularProvider","$stateProvider","$urlRouterProvider",function(a,b,c,d){return a.html5Mode(!1).hashPrefix("!"),b.setRestangularFields({id:"_id"}),b.setBaseUrl("http://api.simple.careers/data/v1/"),d.otherwise("/app/0"),c.state("intro",{url:"/intro",views:{main:{templateUrl:"/views/intro/intro.html",controller:"IntroCtrl"}}}).state("intro.page",{url:"/page",views:{"main.intro":{templateUrl:"/views/intro/intro-page.html",controller:"IntroPageCtrl"}}}).state("app",{url:"/app",views:{main:{templateUrl:"/views/app/app.html",controller:"AppCtrl"}}}).state("app.job",{url:"/:jobId",views:{"main.view":{templateUrl:"/views/app/job.html",controller:"AppJobCtrl"}}}).state("app.job.login",{url:"/?userId&token",views:{main:{templateUrl:"/views/intro/intro.html",controller:"IntroCtrl"}}})}])}).call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}};a=function(){function a(a){var c,d,e,f;for(this.scope=a,this.convert=b(this.convert,this),this.save=b(this.save,this),this.update=b(this.update,this),f=_.functions(this),d=0,e=f.length;e>d;d++)c=f[d],"constructor"!==c&&(this.scope[c]=this[c]);this.scope.save=_.debounce(this.scope.save,1e3)}return a.$inject=["$scope"],a.prototype.update=function(a,b){var c,d=this;return this.scope.$emit("notification",{message:"updating..."}),c=this.Restangular.one(a.route,a._id),c[b]=a[b],c.put().then(function(){return d.scope.$emit("notification",{message:"done"})})},a.prototype.save=function(a,b){var c=this;return null==b&&(b=function(){}),this.scope.$emit("notification",{message:"updating..."}),a.put().then(function(){return b(),c.scope.$emit("notification",{message:"done"})})},a.prototype.convert=function(a){var b;if(a)return b=a.url,/gif/.test(a.mimetype)?b:/filepicker/.test(b)?""+b+"/convert?w=600&h=450":b},a}(),window.Ctrl=a}.call(this),function(){"use strict";angular.module("simplecareersApp").controller("MainCtrl",["$scope",function(a){return a.desc=""}])}.call(this),function(){"use strict";angular.module("simplecareersApp").controller("UserCtrl",["$scope",function(a){return a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma"]}])}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,console.log(this.state),console.log(this.stateParams),b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("IntroCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){this.scope=a,this.stateParams=d,this.state=e,this.ionicSlideBoxDelegate=f,this.Restangular=g,this.slideChanged=b(this.slideChanged,this),this.previous=b(this.previous,this),this.next=b(this.next,this),this.startApp=b(this.startApp,this),c.__super__.constructor.call(this,this.scope)}return d(c,a),c.$inject=["$scope","$stateParams","$state","$ionicSlideBoxDelegate","Restangular"],c.prototype.startApp=function(){this.state.go("app")},c.prototype.next=function(){this.ionicSlideBoxDelegate.next()},c.prototype.previous=function(){this.ionicSlideBoxDelegate.previous()},c.prototype.slideChanged=function(a){this.scope.slideIndex=a},c}(Ctrl),angular.module("simplecareersApp").controller("IntroPageCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e,f){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,this.timeout=f,b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular","$timeout"],b}(Ctrl),angular.module("simplecareersApp").controller("AppCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("AppEmployerCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){var h=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.apply=b(this.apply,this),this.flipClick=b(this.flipClick,this),this.isValid=b(this.isValid,this),this.cardSwiped=b(this.cardSwiped,this),this.cardDrag=b(this.cardDrag,this),this.cardSwipedRight=b(this.cardSwipedRight,this),this.cardSwipedLeft=b(this.cardSwipedLeft,this),this.cardDestroyed=b(this.cardDestroyed,this),this.yesClick=b(this.yesClick,this),this.noClick=b(this.noClick,this),this.checkLogin=b(this.checkLogin,this),this.logout=b(this.logout,this),c.__super__.constructor.call(this,this.scope),console.log(this.state),this.skip=this.state.params.jobId,this.resource=this.Restangular.all("jobs"),this.resource.getList({sort:"order",skip:this.skip,limit:1}).then(function(a){return a&&a.length>0?(h.scope.desc=a[0].jobtagline,a.splice(0,0,{}),a.splice(0,0,{}),h.scope.jobs=a):void 0},function(){return h.skip=0,window.location.hash="/app/"+h.skip})}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout"],c.prototype.logout=function(){return localStorage.removeItem("userId")},c.prototype.checkLogin=function(a){var b,c=this;return this.scope.user?void("function"==typeof a&&a(this.scope.user)):(b=localStorage.getItem("userId"),this.resource=this.Restangular.one("users",""),void this.resource.post({}).then(function(b){return c.scope.user=b,"function"==typeof a?a(c.scope.user):void 0}))},c.prototype.noClick=function(){!this.checkLogin()},c.prototype.yesClick=function(){!this.checkLogin()},c.prototype.cardDestroyed=function(){},c.prototype.cardSwipedLeft=function(){},c.prototype.cardSwipedRight=function(){},c.prototype.cardDrag=function(a,b,c){return-50>a?c.$$status="left":a>50?c.$$status="right":void 0},c.prototype.cardSwiped=function(){var a=this;return this.timeout(function(){return a.skip++,window.location.hash="/app/"+a.skip},500)},c.prototype.isValid=function(a){return a.position&&a.companyname&&a.logo&&a.location&&a.type&&a.picture},c.prototype.flipClick=function(a){return this.applyClicked||(a.$$flip=!a.$$flip),this.applyClicked=!1},c.prototype.apply=function(a){a.preventDefault(),this.applyClicked=!0},c}(Ctrl),angular.module("simplecareersApp").controller("AppJobCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("AppStudentCtrl",a)}.call(this);
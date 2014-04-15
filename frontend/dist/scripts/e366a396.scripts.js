(function(){"use strict";var a;!function(){var a,b,c;for(a=0,b=["webkit","moz"],c=0;c<b.length&&!window.requestAnimationFrame;)window.requestAnimationFrame=window[b[c]+"RequestAnimationFrame"],window.cancelAnimationFrame=window[b[c]+"CancelAnimationFrame"]||window[b[c]+"CancelRequestAnimationFrame"],++c;window.requestAnimationFrame||(window.requestAnimationFrame=function(b){var c,d,e;return c=(new Date).getTime(),e=Math.max(0,16-(c-a)),d=window.setTimeout(function(){b(c+e)},e),a=c+e,d}),window.cancelAnimationFrame||(window.cancelAnimationFrame=function(a){clearTimeout(a)})}(),window.rAF=window.requestAnimationFrame,function(a){var b,c,d,e,f,g,h,i;for(f=document.createElement("div"),h=["webkitTransformOrigin","transform-origin","-webkit-transform-origin","webkit-transform-origin","-moz-transform-origin","moz-transform-origin","MozTransformOrigin","mozTransformOrigin"],d="webkitTransformOrigin",g=0;g<h.length;){if(void 0!==f.style[h[g]]){d=h[g];break}g++}for(i=["webkitTransition","transition","-webkit-transition","webkit-transition","-moz-transition","moz-transition","MozTransition","mozTransition"],e="webkitTransition",g=0;g<i.length;){if(void 0!==f.style[i[g]]){e=i[g];break}g++}b=a.controllers.ViewController.inherit({initialize:function(a){var b;this.cards=[],b=window.innerWidth/window.innerHeight,this.maxWidth=window.innerWidth-(a.cardGutterWidth||0),this.maxHeight=a.height||300,this.cardGutterWidth=a.cardGutterWidth||10,this.cardPopInDuration=a.cardPopInDuration||400,this.cardAnimation=a.cardAnimation||"pop-in"},pushCard:function(a){var b;b=this,this.cards.push(a),this.beforeCardShow(a),a.transitionIn(this.cardAnimation),setTimeout(function(){a.disableTransition(b.cardAnimation)},this.cardPopInDuration+100)},beforeCardShow:function(){var a,b,c;b=this.cards[this.cards.length-1],b&&(c=window.innerHeight/2-this.maxHeight/2,a=5*Math.min(this.cards.length,3),b.setPopInDuration(this.cardPopInDuration),b.setZIndex(10*this.cards.length))},popCard:function(a){var b;return b=this.cards.pop(),a&&b.swipe(),b}}),c=a.views.View.inherit({initialize:function(b){b=a.extend({},b),a.extend(this,b),this.el=b.el,this.enable=!0,this.startX=this.startY=this.x=this.y=0,this.bindEvents()},setX:function(b){this.el.style[a.CSS.TRANSFORM]="translate3d("+b+"px,"+this.y+"px, 0)",this.x=b,this.startX=b},setY:function(b){this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px,"+b+"px, 0)",this.y=b,this.startY=b},setZIndex:function(a){this.el.style.zIndex=a},setWidth:function(a){this.el.style.width=a+"px"},setHeight:function(a){this.el.style.height=a+"px"},setPopInDuration:function(a){this.cardPopInDuration=a},transitionIn:function(a){var b;b=this,this.el.classList.add(a+"-start"),this.el.classList.add(a),this.el.style.display="block",setTimeout(function(){b.el.classList.remove(a+"-start")},100)},setEnable:function(a){return this.enable=a},disableTransition:function(a){this.el.classList.remove(a)},swipe:function(){this.transitionOut()},transitionOut:function(){var b,c,d;d=this,this.x>-50&&this.x<50?(this.el.style[e]="-webkit-transform 0.2s ease-in-out",this.el.style[a.CSS.TRANSFORM]="translate3d("+this.startX+"px,"+this.startY+"px, 0)",setTimeout(function(){d.el.style[e]="none"},200)):(c=this.rotationAngle+.6*this.rotationDirection||.4*Math.random(),b=this.rotationAngle?.3:.5,this.el.style[e]="-webkit-transform "+b+"s ease-in-out",this.x<-50?(this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px,"+3*window.innerHeight+"px, 0) rotate("+c+"rad)",this.onSwipeLeft&&this.onSwipeLeft()):(this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px,"+3*window.innerHeight+"px, 0) rotate("+c+"rad)",this.onSwipeRight&&this.onSwipeRight()),this.onSwipe&&this.onSwipe(),setTimeout(function(){d.onDestroy&&d.onDestroy()},1e3*b))},bindEvents:function(){var b,c=this;b=this,a.onGesture("dragstart",function(a){var d;c.enable&&(a.preventDefault(),d=window.innerWidth/2,a.gesture.touches[0].pageX<d?b._transformOriginRight():b._transformOriginLeft(),window.rAF(function(){b._doDragStart(a)}))},this.el),a.onGesture("drag",function(a){c.enable&&(a.preventDefault(),window.rAF(function(){b._doDrag(a)}))},this.el),a.onGesture("dragend",function(a){c.enable&&(a.preventDefault(),window.rAF(function(){b._doDragEnd(a)}))},this.el)},_transformOriginLeft:function(){this.el.style[d]="left center",this.rotationDirection=1},_transformOriginRight:function(){this.el.style[d]="right center",this.rotationDirection=-1},_doDragStart:function(a){var b,c,d;d=this.el.offsetWidth,c=window.innerWidth/2+this.rotationDirection*(d/2),b=Math.abs(c-a.gesture.touches[0].pageY),this.touchDistance=10*b,this.onDragStart()},_doDrag:function(b){var c;c=b.gesture.deltaY/3,this.rotationAngle=Math.atan(c/this.touchDistance)*this.rotationDirection,b.gesture.deltaY<0&&(this.rotationAngle=0),this.x=this.startX+b.gesture.deltaX,this.y=this.startY+b.gesture.deltaY,this.el.style[a.CSS.TRANSFORM]="translate3d("+this.x+"px, "+this.y+"px, 0) rotate("+(this.rotationAngle||0)+"rad)",this.onDrag(this.x,this.y)},_doDragEnd:function(a){this.onDragEnd(),this.transitionOut(a)}}),angular.module("ionic.contrib.ui.cards",["ionic"]).directive("swipeCard",["$timeout",function(a){return{restrict:"E",template:'<div class="swipe-card" ng-transclude></div>',require:"^swipeCards",replace:!0,transclude:!0,scope:{onDragging:"&",onDragStart:"&",onDragEnd:"&",onSwipeLeft:"&",onSwipeRight:"&",onSwipe:"&",onDestroy:"&"},compile:function(){return function(b,d,e,f){var g,h;g=d[0],h=new c({el:g,onDrag:function(c,d){a(function(){"function"==typeof b.onDragging&&b.onDragging({$x:c,$y:d})})},onDragStart:function(){a(function(){"function"==typeof b.onDragStart&&b.onDragStart()})},onDragEnd:function(){a(function(){"function"==typeof b.onDragEnd&&b.onDragEnd()})},onSwipeRight:function(){a(function(){"function"==typeof b.onSwipeRight&&b.onSwipeRight()})},onSwipeLeft:function(){a(function(){"function"==typeof b.onSwipeLeft&&b.onSwipeLeft()})},onSwipe:function(){a(function(){"function"==typeof b.onSwipe&&b.onSwipe()})},onDestroy:function(){a(function(){"function"==typeof b.onDestroy&&b.onDestroy()})}}),b.$parent.swipeCard=h,f.pushCard(h)}}}}]).directive("swipeCards",["$rootScope",function(a){return{restrict:"E",template:'<div class="swipe-cards" ng-transclude></div>',replace:!0,transclude:!0,scope:{},controller:function(){var c;return c=new b({}),a.$on("swipeCard.pop",function(a){c.popCard(a)}),c}}}]).factory("$ionicSwipeCardDelegate",["$rootScope",function(a){return{popCard:function(b,c){a.$emit("swipeCard.pop",c)},getSwipebleCard:function(a){return a.$parent.swipeCard}}}])}(window.ionic),a=angular.module("simplecareersApp",["ngCookies","ngResource","ngSanitize","ngSocial","ionic","ionic.contrib.ui.cards","restangular"]).config(["$locationProvider","RestangularProvider","$stateProvider","$urlRouterProvider",function(a,b,c,d){return b.setRestangularFields({id:"_id"}),b.setBaseUrl("http://api.simple.careers/data/v1/"),d.otherwise("/app/all/0"),c.state("intro",{url:"/intro",views:{main:{templateUrl:"/views/intro/intro.html",controller:"IntroCtrl"}}}).state("intro.page",{url:"/page",views:{"main.intro":{templateUrl:"/views/intro/intro-page.html",controller:"IntroPageCtrl"}}}).state("app",{url:"/app",views:{main:{templateUrl:"/views/app/app.html",controller:"AppCtrl"}}}).state("app.all",{url:"/all",views:{"main.view":{templateUrl:"/views/app/item.html",controller:"AppItemCtrl"}}}).state("app.all.job",{url:"/:jobId",views:{"main.view.view":{templateUrl:"/views/app/job.html",controller:"AppAllJobCtrl"}}}).state("app.favorite",{url:"/favorite",views:{"main.view":{templateUrl:"/views/app/item.html",controller:"AppItemCtrl"}}}).state("app.favorite.job",{url:"/:jobId",views:{"main.view.view":{templateUrl:"/views/app/job.html",controller:"AppFavoriteJobCtrl"}}}).state("app.apply",{url:"/apply",views:{"main.view":{templateUrl:"/views/app/item.html",controller:"AppItemCtrl"}}}).state("app.apply.job",{url:"/:jobId",views:{"main.view.view":{templateUrl:"/views/app/job.html",controller:"AppApplyJobCtrl"}}}).state("app.login",{url:"/?userId&token&redirect",views:{"main.view":{templateUrl:"/views/app/login.html",controller:"AppLoginCtrl"}}}).state("app.logout",{url:"/logout",views:{"main.view":{templateUrl:"/views/app/logout.html",controller:"AppLogoutCtrl"}}})}]),a.factory("preloader",["$q","$rootScope",function(a,b){var c,d,e,f,g,h,i,j;return c=function(b){this.imageLocations=b,this.imageCount=this.imageLocations.length,this.loadCount=0,this.errorCount=0,this.states={PENDING:1,LOADING:2,RESOLVED:3,REJECTED:4},this.state=this.states.PENDING,this.deferred=a.defer(),this.promise=this.deferred.promise},c.preloadImages=function(a){var b;return b=new c(a),b.load()},c.prototype={constructor:c,isInitiated:f=function(){return this.state!==this.states.PENDING},isRejected:g=function(){return this.state===this.states.REJECTED},isResolved:h=function(){return this.state===this.states.RESOLVED},load:i=function(){var a;if(this.isInitiated())return this.promise;for(this.state=this.states.LOADING,a=0;a<this.imageCount;)this.loadImageLocation(this.imageLocations[a]),a++;return this.promise},handleImageError:d=function(a){this.errorCount++,this.isRejected()||(this.state=this.states.REJECTED,this.deferred.reject(a))},handleImageLoad:e=function(a){this.loadCount++,this.isRejected()||(this.deferred.notify({percent:Math.ceil(this.loadCount/this.imageCount*100),imageLocation:a}),this.loadCount===this.imageCount&&(this.state=this.states.RESOLVED,this.deferred.resolve(this.imageLocations)))},loadImageLocation:j=function(a){var c,d;d=this,c=$(new Image).load(function(a){b.$apply(function(){d.handleImageLoad(a.target.src),d=c=a=null})}).error(function(a){b.$apply(function(){d.handleImageError(a.target.src),d=c=a=null})}).prop("src",a)}},c}])}).call(this),function(){"use strict";var a,b,c=function(a,b){return function(){return a.apply(b,arguments)}};b={},a=function(){function a(a){var b,d,e,f;for(this.scope=a,this.myPagingFunction=c(this.myPagingFunction,this),this.wait=c(this.wait,this),this.convert=c(this.convert,this),this.save=c(this.save,this),this.update=c(this.update,this),this.jobRequest=c(this.jobRequest,this),this.purgeJobCache=c(this.purgeJobCache,this),this.checkLogin=c(this.checkLogin,this),f=_.functions(this),d=0,e=f.length;e>d;d++)b=f[d],"constructor"!==b&&(this.scope[b]=this[b]);this.scope.save=_.debounce(this.scope.save,1e3)}return a.$inject=["$scope"],a.prototype.checkLogin=function(a,b,c){var d,e,f;return f=localStorage.getItem("userId"),e=localStorage.getItem("token"),f&&e?a.user?void("function"==typeof c&&c(a.user)):(b.setDefaultHeaders({Authorization:"Bearer "+localStorage.getItem("token")}),d=b.one("users",localStorage.getItem("userId")),d.get().then(function(b){return a.user=b,"function"==typeof c?c(b):void 0})):void(window.location.href="/auth/linkedin?redirect="+window.location.hash.replace("#",""))},a.prototype.purgeJobCache=function(){return b={}},a.prototype.jobRequest=function(a,c,d,e,f){var g,h,i;return h=JSON.stringify(d),(g=b[h])?(delete b[h],void("function"==typeof e&&e([g]))):(i=a.all("jobs"),i.getList(d).then(function(a){var d;return a&&a.length>0&&(g=a[0],b[h]=g,"function"==typeof c&&c([null!=(d=g.picture)?d.url:void 0]).then(function(){})),"function"==typeof e?e(a):void 0},function(){return"function"==typeof f?f.apply(null,arguments):void 0}))},a.prototype.update=function(a,b){var c,d=this;return this.scope.$emit("notification",{message:"updating..."}),c=this.Restangular.one(a.route,a._id),c[b]=a[b],c.put().then(function(){return d.scope.$emit("notification",{message:"done"})})},a.prototype.save=function(a,b){var c=this;return null==b&&(b=function(){}),this.scope.$emit("notification",{message:"updating..."}),a.put().then(function(){return b(),c.scope.$emit("notification",{message:"done"})})},a.prototype.convert=function(a){var b;if(a)return b=a.url,/gif/.test(a.mimetype)?b:/filepicker/.test(b)?""+b+"/convert?w=600&h=450":b},a.prototype.wait=function(a,b,c){var d;return a[b]?c():d=a.$watch(b,function(){return a[b]?(c(),d()):void 0})},a.prototype.myPagingFunction=function(){var a=this;if(!this.scope.pagingBusy&&!this.scope.pagingDone&&this.filter)return this.scope.pagingBusy=!0,"function"==typeof this.pagingFn?this.pagingFn(function(b){return b.length>0?a.scope[a.pagingKey]=a.scope[a.pagingKey]?a.scope[a.pagingKey].concat(b):b:a.scope.pagingDone=!0,a.scope.page++,a.scope.pagingBusy=!1}):void 0},a}(),window.Ctrl=a}.call(this),function(){"use strict";angular.module("simplecareersApp").controller("MainCtrl",["$scope",function(a){return a.desc=""}])}.call(this),function(){"use strict";angular.module("simplecareersApp").controller("UserCtrl",["$scope",function(a){return a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma"]}])}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("IntroCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){this.scope=a,this.stateParams=d,this.state=e,this.ionicSlideBoxDelegate=f,this.Restangular=g,this.slideChanged=b(this.slideChanged,this),this.previous=b(this.previous,this),this.next=b(this.next,this),this.startApp=b(this.startApp,this),c.__super__.constructor.call(this,this.scope)}return d(c,a),c.$inject=["$scope","$stateParams","$state","$ionicSlideBoxDelegate","Restangular"],c.prototype.startApp=function(){this.state.go("app")},c.prototype.next=function(){this.ionicSlideBoxDelegate.next()},c.prototype.previous=function(){this.ionicSlideBoxDelegate.previous()},c.prototype.slideChanged=function(a){this.scope.slideIndex=a},c}(Ctrl),angular.module("simplecareersApp").controller("IntroPageCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){var h=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.yesClick=b(this.yesClick,this),this.noClick=b(this.noClick,this),c.__super__.constructor.call(this,this.scope),this.scope.$state=this.state,this.scope.url=void 0,this.scope.swipeCard=void 0,this.skip=this.state.params.jobId,this.resource=this.Restangular.all("jobs"),this.resource.getList({sort:"order",skip:this.skip,limit:1}).then(function(a){return a&&a.length>0?(h.scope.desc=a[0].jobtagline,a.splice(0,0,{}),a.splice(0,0,{}),h.scope.jobs=a):void 0},function(){return h.skip=0,window.location.hash="/app/"+h.skip}),this.scope.$on("shareUrl",function(a,b){return h.scope.url=b}),this.scope.$on("setEnableShare",function(a,b){return h.scope.enableShare=b})}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout"],c.prototype.noClick=function(){return this.scope.$broadcast("noClick")},c.prototype.yesClick=function(){return this.scope.$broadcast("yesClick")},c}(Ctrl),angular.module("simplecareersApp").controller("AppCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("AppEmployerCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g,h){var i=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.preloader=h,this.apply=b(this.apply,this),this.flipClick=b(this.flipClick,this),this.cardSwiped=b(this.cardSwiped,this),this.cardDrag=b(this.cardDrag,this),this.isValid=b(this.isValid,this),this.cardDragEnd=b(this.cardDragEnd,this),this.cardDragStart=b(this.cardDragStart,this),this.cardSwipedRight=b(this.cardSwipedRight,this),this.cardSwipedLeft=b(this.cardSwipedLeft,this),this.cardDestroyed=b(this.cardDestroyed,this),c.__super__.constructor.call(this,this.scope),this.skip=this.state.params.jobId,this.resource=this.Restangular.all("jobs"),this.resource.getList({sort:"order",skip:this.skip,limit:1}).then(function(a){return a&&a.length>0?(i.scope.job=a[0],i.scope.job.$$flip=!1,i.scope.isLoading=!0,i.scope.status="loading",i.isValid(i.scope.job)?i.preloader.preloadImages([i.scope.job.picture.url]).then(function(){return i.scope.status="normal",i.scope.isLoading=!1,i.scope.isSuccessful=!0},function(){return i.scope.status="normal",i.scope.isLoading=!1,i.scope.isSuccessful=!1}):void(i.scope.status="broken")):void 0},function(){return i.skip=0,window.location.hash="/app/"+i.skip}),this.scope.$on("noClick",function(){return i.scope.status="pass",i.scope.swipeCard.setX(-500),i.scope.swipeCard.transitionOut()}),this.scope.$on("yesClick",function(){return i.scope.status="fav",i.scope.swipeCard.setX(500),i.scope.swipeCard.transitionOut()})}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout","preloader"],c.prototype.cardDestroyed=function(){},c.prototype.cardSwipedLeft=function(){return this.scope.user.favorites=_.without(this.scope.user.favorites,this.scope.job._id),this.scope.update(this.scope.user,"favorites")},c.prototype.cardSwipedRight=function(){var a;return null==(a=this.scope.user).favorites&&(a.favorites=[]),this.scope.user.favorites.push(this.scope.job._id),this.scope.update(this.scope.user,"favorites")},c.prototype.cardDragStart=function(){},c.prototype.cardDragEnd=function(){return this.dragging=!1},c.prototype.isValid=function(a){return a?a.position&&a.companyname&&a.logo&&a.location&&a.type&&a.picture:!1},c.prototype.cardDrag=function(a){return this.dragging=!0,this.scope.status=-50>a?"pass":a>50?"fav":this.isValid(this.scope.job)?"normal":"broken"},c.prototype.cardSwiped=function(){var a=this;return this.timeout(function(){return a.skip++,window.location.hash="/app/"+a.skip},500)},c.prototype.flipClick=function(a){return this.applyClicked||this.dragging||(a.$$flip=!a.$$flip),this.applyClicked=!1},c.prototype.apply=function(a){a.preventDefault(),this.applyClicked=!0,window.location.href="/auth/linkedin?redirect="+window.location.hash},c}(Ctrl),angular.module("simplecareersApp").controller("AppJobCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("AppStudentCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope),localStorage.setItem("userId",this.stateParams.userId),localStorage.setItem("token",this.stateParams.token),window.location.hash=this.stateParams.redirect}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("AppLoginCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope),localStorage.removeItem("userId",this.stateParams.userId),localStorage.removeItem("token",this.stateParams.token),window.location.hash="/app/all/0"}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("AppLogoutCtrl",a)}.call(this),function(){"use strict";var a,b={}.hasOwnProperty,c=function(a,c){function d(){this.constructor=a}for(var e in c)b.call(c,e)&&(a[e]=c[e]);return d.prototype=c.prototype,a.prototype=new d,a.__super__=c.prototype,a};a=function(a){function b(a,c,d,e){this.scope=a,this.stateParams=c,this.state=d,this.Restangular=e,b.__super__.constructor.call(this,this.scope)}return c(b,a),b.$inject=["$scope","$stateParams","$state","Restangular"],b}(Ctrl),angular.module("simplecareersApp").controller("AppItemCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g,h){this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.preloader=h,this.apply=b(this.apply,this),this.flipClick=b(this.flipClick,this),this.cardSwiped=b(this.cardSwiped,this),this.cardDrag=b(this.cardDrag,this),this.isValid=b(this.isValid,this),this.cardDragEnd=b(this.cardDragEnd,this),this.cardDragStart=b(this.cardDragStart,this),this.cardSwipedRight=b(this.cardSwipedRight,this),this.cardSwipedLeft=b(this.cardSwipedLeft,this),this.cardDestroyed=b(this.cardDestroyed,this),this.newQuery=b(this.newQuery,this),this.initButtonEvents=b(this.initButtonEvents,this),this.init=b(this.init,this),c.__super__.constructor.call(this,this.scope),this.scope.$state=this.state}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout","preloader"],c.prototype.init=function(){var a=this;return this.skip=+this.state.params.jobId,this.jobRequest(this.Restangular,this.preloader.preloadImages,this.newQuery(+this.skip),function(b){return a.jobRequest(a.Restangular,a.preloader.preloadImages,a.newQuery(+a.skip+1)),b&&b.length>0?(a.scope.job=b[0],a.scope.$emit("shareUrl",window.location.href),a.scope.job.$$flip=!1,a.scope.isLoading=!0,a.scope.status="loading",a.isValid(a.scope.job)?a.preloader.preloadImages([a.scope.job.picture.url]).then(function(){return a.scope.status="normal",a.scope.isLoading=!1,a.scope.isSuccessful=!0},function(){return a.scope.status="normal",a.scope.isLoading=!1,a.scope.isSuccessful=!1}):void(a.scope.status="broken")):void 0},function(){return 0===+a.skip?(a.scope.status="empty",void a.scope.swipeCard.setEnable(!1)):(a.skip=0,window.location.hash="/app/"+a.type+"/"+a.skip)}),this.initButtonEvents()},c.prototype.initButtonEvents=function(){var a=this;return"function"==typeof this.noLis&&this.noLis(),this.noLis=this.scope.$on("noClick",function(){return a.scope.swipeCard.enable?(a.scope.status="pass",a.scope.swipeCard.setX(-500),a.scope.swipeCard.transitionOut()):void 0}),"function"==typeof this.yesLis&&this.yesLis(),this.yesLis=this.scope.$on("yesClick",function(){return a.scope.swipeCard.enable?(a.scope.status="fav",a.scope.swipeCard.setX(500),a.scope.swipeCard.transitionOut()):void 0})},c.prototype.newQuery=function(a){var b;return b={sort:"order",skip:a,limit:1}},c.prototype.cardDestroyed=function(){},c.prototype.cardSwipedLeft=function(){var a=this;return this.checkLogin(this.scope,this.Restangular,function(b){return a.scope.user=b,a.Restangular.all("userfavorites").remove({conditions:{user:b._id,job:a.scope.job._id}})})},c.prototype.cardSwipedRight=function(){var a=this;return this.checkLogin(this.scope,this.Restangular,function(b){return a.scope.user=b,a.Restangular.all("userfavorites").post({user:b._id,job:a.scope.job._id})})},c.prototype.cardDragStart=function(){},c.prototype.cardDragEnd=function(){return this.dragging=!1},c.prototype.isValid=function(a){return a?a.position&&a.companyname&&a.logo&&a.location&&a.type&&a.picture:!1},c.prototype.cardDrag=function(a){return this.dragging=!0,this.scope.status=-50>a?"pass":a>50?"fav":this.isValid(this.scope.job)?"normal":"broken"},c.prototype.cardSwiped=function(){var a=this;return this.timeout(function(){return a.skip++,window.location.hash="/app/"+a.type+"/"+a.skip},100)},c.prototype.flipClick=function(a){return this.applyClicked||this.dragging||null!=a&&(a.$$flip=!(null!=a?a.$$flip:void 0)),this.applyClicked=!1},c.prototype.apply=function(a){a.preventDefault(),this.applyClicked=!0,window.location="/auth/linkedin?redirect="+window.location.hash.replace("#","")+"&apply="+this.scope.job._id},c}(Ctrl),window.AppCommonJobCtrl=a}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g,h){var i=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.preloader=h,this.newQuery=b(this.newQuery,this),this.init=b(this.init,this),c.__super__.constructor.call(this,this.scope,this.stateParams,this.state,this.Restangular,this.timeout,this.preloader),this.type="apply",this.scope.$emit("setEnableShare",!1),this.checkLogin(this.scope,this.Restangular,function(a){return i.scope.user=a,i.init()})}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout","preloader"],c.prototype.init=function(){var a=this;return this.skip=+this.state.params.jobId,this.resource=this.Restangular.all("userapplies"),this.resource.getList(this.newQuery(this.skip)).then(function(b){return a.scope.job=b[0].job,a.scope.$emit("shareUrl",window.location.href),a.scope.job.$$flip=!1,a.scope.isLoading=!0,a.scope.status="loading",a.isValid(a.scope.job)?a.preloader.preloadImages([a.scope.job.picture.url]).then(function(){return a.scope.status="normal",a.scope.isLoading=!1,a.scope.isSuccessful=!0},function(){return a.scope.status="normal",a.scope.isLoading=!1,a.scope.isSuccessful=!1}):void(a.scope.status="broken")},function(){return 0===+a.skip?(a.scope.status="empty",void a.scope.swipeCard.setEnable(!1)):(a.skip=0,window.location.hash="/app/"+a.type+"/"+a.skip)}),this.initButtonEvents()},c.prototype.newQuery=function(a){var b;return b=c.__super__.newQuery.call(this,a),b.populate="job",b},c}(AppCommonJobCtrl),angular.module("simplecareersApp").controller("AppApplyJobCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g,h,i){var j=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.preloader=h,this.window=i,this.cardSwipedRight=b(this.cardSwipedRight,this),this.cardSwipedLeft=b(this.cardSwipedLeft,this),this.newQuery=b(this.newQuery,this),this.init=b(this.init,this),c.__super__.constructor.call(this,this.scope,this.stateParams,this.state,this.Restangular,this.timeout,this.preloader),this.type="favorite",this.scope.$emit("setEnableShare",!1),this.checkLogin(this.scope,this.Restangular,function(a){return j.scope.user=a,j.init()})}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout","preloader","$window"],c.prototype.init=function(){var a=this;return this.skip=+this.state.params.jobId,this.resource=this.Restangular.all("userfavorites"),this.resource.getList(this.newQuery(this.skip)).then(function(b){return a.scope.job=b[0].job,a.scope.$emit("shareUrl",window.location.href),a.scope.job.$$flip=!1,a.scope.isLoading=!0,a.scope.status="loading",a.isValid(a.scope.job)?a.preloader.preloadImages([a.scope.job.picture.url]).then(function(){return a.scope.status="normal",a.scope.isLoading=!1,a.scope.isSuccessful=!0},function(){return a.scope.status="normal",a.scope.isLoading=!1,a.scope.isSuccessful=!1}):void(a.scope.status="broken")},function(){return 0===+a.skip?(a.scope.status="empty",void a.scope.swipeCard.setEnable(!1)):(a.skip=0,window.location.hash="/app/"+a.type+"/"+a.skip)}),this.initButtonEvents()},c.prototype.newQuery=function(a){var b;return b=c.__super__.newQuery.call(this,a),b.populate="job",b},c.prototype.cardSwipedLeft=function(a){var b=this;return this.skip--,c.__super__.cardSwipedLeft.call(this,a),this.timeout(function(){return b.purgeJobCache(),location.reload()},110)},c.prototype.cardSwipedRight=function(a){return c.__super__.cardSwipedRight.call(this,a)},c}(AppCommonJobCtrl),angular.module("simplecareersApp").controller("AppFavoriteJobCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g,h){this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.preloader=h,this.newQuery=b(this.newQuery,this),c.__super__.constructor.call(this,this.scope,this.stateParams,this.state,this.Restangular,this.timeout,this.preloader),this.type="all",this.scope.$emit("setEnableShare",!0),this.init()}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout","preloader"],c.prototype.newQuery=function(a){var b;return b=c.__super__.newQuery.call(this,a)},c}(AppCommonJobCtrl),angular.module("simplecareersApp").controller("AppAllJobCtrl",a)}.call(this);
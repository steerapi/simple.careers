(function(){"use strict";filepicker.setKey("A7hqLKRidRZIvOwJrVOLpz"),angular.module("simpleannotateApp",["ngCookies","ngResource","ngSanitize","ui.router","ui.sortable","restangular"]).config(["RestangularProvider","$stateProvider","$urlRouterProvider",function(a,b,c){return a.setRestangularFields({id:"_id"}),a.setBaseUrl("/api/data/"),a.setDefaultHeaders({Authorization:"Bearer 5168fb941960bec6afaa7b23f2d0fa92"}),c.otherwise("/job"),b.state("job",{url:"/job",views:{view:{templateUrl:"./views/job.html",controller:"JobCtrl"}}}).state("job.item",{url:"/:jobId",views:{"view.view":{templateUrl:"./views/job-item.html",controller:"JobItemCtrl"}}}).state("job.item.desc",{url:"/desc",views:{"view.view.view":{templateUrl:"./views/job-desc.html",controller:"JobDescCtrl"}}}).state("job.item.app",{url:"/app",views:{"view.view.view":{templateUrl:"./views/job-app.html",controller:"JobAppCtrl"}}})}])}).call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}};a=function(){function a(a){var c,d,e,f;for(this.scope=a,this.wait=b(this.wait,this),this.save=b(this.save,this),this.update=b(this.update,this),f=_.functions(this),d=0,e=f.length;e>d;d++)c=f[d],"constructor"!==c&&(this.scope[c]=this[c]);this.scope.save=_.debounce(this.scope.save,1e3)}return a.$inject=["$scope"],a.prototype.update=function(a,b){var c,d=this;return this.scope.$emit("notification",{message:"updating..."}),c=this.Restangular.one(a.route,a._id),c[b]=a[b],c.put().then(function(){return d.scope.$emit("notification",{message:"done"})})},a.prototype.save=function(a,b){var c=this;return null==b&&(b=function(){}),this.scope.$emit("notification",{message:"updating..."}),a.put().then(function(){return b(),c.scope.$emit("notification",{message:"done"})})},a.prototype.wait=function(a,b,c){var d;return a[b]?c():d=a.$watch(b,function(a){return a?(c(),d()):void 0})},a}(),window.Ctrl=a}.call(this),function(){"use strict";angular.module("simpleannotateApp").controller("AppCtrl",["$scope",function(a){return a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma"]}])}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){var h=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.changeJob=b(this.changeJob,this),this.removeJob=b(this.removeJob,this),this.newJob=b(this.newJob,this),c.__super__.constructor.call(this,this.scope),this.scope.mode="desc",this.scope.$on("changeMode",function(a,b){return h.scope.mode=b}),this.scope.sortableOptions={update:function(){h.timeout(function(){var a;return null!=(a=h.scope.jobs)?a.forEach(function(a,b){return a.order=b,h.save(a)}):void 0})}},this.resource=this.Restangular.all("jobs"),this.resource.getList({sort:"order"}).then(function(a){var b,c,d,e,f;if(h.scope.jobs=a,h.state.params.jobId){for(e=h.scope.jobs,f=[],c=0,d=e.length;d>c;c++)b=e[c],f.push(b._id===h.state.params.jobId?h.scope.job=b:void 0);return f}}),this.scope.job=null}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular","$timeout"],c.prototype.newJob=function(){var a,b,c=this;return null==(b=this.scope).jobs&&(b.jobs=[]),a={order:this.scope.jobs.length},this.resource.post(a).then(function(a){return c.scope.jobs.push(a)})},c.prototype.removeJob=function(a,b){var c,d,e,f,g;for(b.stopPropagation(),g=this.scope.jobs,c=e=0,f=g.length;f>e;c=++e)if(d=g[c],d&&a&&a._id===d._id){this.scope.jobs.splice(c,1),a.remove();break}},c.prototype.changeJob=function(a){this.scope.job=a,this.state.go("job.item."+this.scope.mode,{jobId:a._id})},c}(Ctrl),angular.module("simpleannotateApp").controller("JobCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.changeTab=b(this.changeTab,this),c.__super__.constructor.call(this,this.scope),this.scope.$state=this.state,this.scope.$stateParams=this.stateParams}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular"],c.prototype.changeTab=function(a){return this.scope.$emit("changeMode",a),this.state.go("job.item."+a,{jobId:this.state.params.jobId})},c}(Ctrl),angular.module("simpleannotateApp").controller("JobItemCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){var h=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.removeBadge=b(this.removeBadge,this),this.pickBadge=b(this.pickBadge,this),this.pickPicture=b(this.pickPicture,this),this.pickLogo=b(this.pickLogo,this),this.pick=b(this.pick,this),c.__super__.constructor.call(this,this.scope),this.scope.$state=this.state,this.scope.$stateParams=this.stateParams,this.scope.sortableOptions={update:function(){return h.save(h.scope.job)}}}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular"],c.prototype.pick=function(a){return filepicker.pick(function(b){return a(b)})},c.prototype.pickLogo=function(){var a=this;return this.pick(function(b){return a.scope.job.logo=b,a.save(a.scope.job)})},c.prototype.pickPicture=function(){var a=this;return this.pick(function(b){return a.scope.job.picture=b,a.save(a.scope.job)})},c.prototype.pickBadge=function(){var a,b=this;return null==(a=this.scope.job).badges&&(a.badges=[]),filepicker.pickMultiple(function(a){var c,d,e;for(d=0,e=a.length;e>d;d++)c=a[d],b.scope.job.badges.push(c);return b.save(b.scope.job)})},c.prototype.removeBadge=function(a){var b,c,d,e,f,g;for(f=this.scope.job.badges,g=[],c=d=0,e=f.length;e>d;c=++d)b=f[c],a&&b&&a.url===b.url?(this.scope.job.badges.splice(c,1),g.push(this.save(this.scope.job))):g.push(void 0);return g},c}(Ctrl),angular.module("simpleannotateApp").controller("JobDescCtrl",a)}.call(this),function(){"use strict";var a,b=function(a,b){return function(){return a.apply(b,arguments)}},c={}.hasOwnProperty,d=function(a,b){function d(){this.constructor=a}for(var e in b)c.call(b,e)&&(a[e]=b[e]);return d.prototype=b.prototype,a.prototype=new d,a.__super__=b.prototype,a};a=function(a){function c(a,d,e,f,g){var h=this;this.scope=a,this.stateParams=d,this.state=e,this.Restangular=f,this.timeout=g,this.removeApp=b(this.removeApp,this),c.__super__.constructor.call(this,this.scope),this.scope.$state=this.state,this.scope.$stateParams=this.stateParams,this.wait(this.scope,"job",function(){return h.resource=h.Restangular.all("userapplies"),h.resource.getList({conditions:{job:h.scope.job._id},populate:"user"}).then(function(a){return h.scope.userapplies=a})})}return d(c,a),c.$inject=["$scope","$stateParams","$state","Restangular"],c.prototype.removeApp=function(a,b){var c=this;return this.resource.remove({conditions:{_id:a._id}}).then(function(){c.scope.userapplies.splice(b,1)})},c}(Ctrl),angular.module("simpleannotateApp").controller("JobAppCtrl",a)}.call(this);
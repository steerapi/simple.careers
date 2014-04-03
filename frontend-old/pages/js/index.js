var app = angular.module('app',[]);
// app.config(['RestangularProvider', function(RestangularProvider, $stateProvider, $urlRouterProvider, config){
//   RestangularProvider.setBaseUrl("http://mobile.fairsey.com/");
// }]);

function setCookie(cname,cvalue)
{
//    var d = new Date();
//    d.setTime(d.getTime()+(exdays*24*60*60*1000));
//    var expires = "expires="+d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";";
}

function getCookie(cname)
{
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++)
    {
        var c = ca[i].trim();
        if (c.indexOf(name)==0) return c.substring(name.length,c.length);
    }
    return "";
}

function clearCookie() {
    var cookies = document.cookie.split(";");

    for (var i = 0; i < cookies.length; i++) {
    	var cookie = cookies[i];
    	var eqPos = cookie.indexOf("=");
    	var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
    	document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
}

app.controller('SignupCtrl', function ($scope,$http) {
  $scope.signup = function(username, password){
    $http.post('http://mobile.fairsey.com/auth/v1/signup',{
      username: username,
      password: password      
    }).success(function(){
      $scope.hideForm = true;
      $scope.success = true;
    }).error(function(){
      // $http.post('http://mobile.fairsey.com/auth/v1/login',{
      //   username: username,
      //   password: password      
      // }).success(function(){
      //   $scope.hideForm = true;
      //   $scope.success = true;
      //   window.location = "http://app.fairsey.com/student";
      // }).error(function(){
      //   $scope.success = false;
      //   $scope.hideForm = true;
      // });
      $scope.success = false;
      $scope.hideForm = true;
    });
  }
});

app.controller('AskusCtrl', function ($scope,$http) {
  $scope.askus = function(name,email,text){
    $http.post('http://mobile.fairsey.com/askus',{
      name: name,
      email: email,
      text: text,
    }).success(function(){
      $scope.hideForm = true;
      $scope.success = true;
      console.log(arguments);
    }).error(function(){
      $scope.hideForm = true;
      $scope.success = false;
      console.log(arguments);      
    });
  }
});
function loadPageVar (sVar) {  
  return unescape(window.location.search.replace(new RegExp("^(?:.*[&\\?]" + escape(sVar).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1"));  
} 
app.controller('SetPasswordCtrl', function ($scope,$http) {
  $scope.setPassword = function(password){
    var token = loadPageVar("token");
    $http.post('http://mobile.fairsey.com/auth/v1/setpass',{
      password: password,
      token: token
    }).success(function(){
      $scope.hideForm = true;
      $scope.success = true;
      console.log(arguments);
    }).error(function(){
      $scope.hideForm = true;
      $scope.success = false;
      console.log(arguments);
    });
  }
});

app.controller('ResetPasswordCtrl', function ($scope,$http) {
  $scope.resetPassword = function(email){
    $http.post('http://mobile.fairsey.com/auth/v1/reset',{
      email: email
    }).success(function(){
      $scope.hideForm = true;
      $scope.success = true;
      console.log(arguments);
    }).error(function(){
      $scope.hideForm = true;
      $scope.success = false;
      console.log(arguments);
    });
  }
});
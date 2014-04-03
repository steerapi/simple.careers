'use strict';

angular.module('frontendApp')
  .controller('MainCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
    $('.single-item').slick({
      arrows: false,
      dots: true
    });
    
  });
  
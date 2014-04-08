'use strict'

class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular) ->
    super @scope
    @scope.cards = [{},{}]
  cardDestroyed: (index)=>
    @scope.cards.splice(index, 1);
  cardSwiped: (index)=>
    newCard = {}
    @scope.cards.push(newCard);
    
angular.module('simplecareersApp').controller('AppCtrl', AppCtrl)

'use strict'

class AppCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular", "$timeout"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @scope.cards = [{_id:1}]
    @count = 4
  cardDestroyed: (index)=>
    @scope.cards.splice(index, 1);
  cardSwiped: (index)=>
    # console.log @scope.cards.length
    # while @scope.cards.length < 4
    newCard = {_id:@count++}
    @scope.cards.push(newCard);
    
angular.module('simplecareersApp').controller('AppCtrl', AppCtrl)

'use strict'

class JobDescCtrl extends Ctrl
  @$inject: ['$scope', '$stateParams', '$state', "Restangular"]
  constructor: (@scope, @stateParams, @state, @Restangular, @timeout) ->
    super @scope
    @scope.$state = @state
    @scope.$stateParams = @stateParams
    @scope.sortableOptions = {
      update: (e, ui)=>
        @save @scope.job
    }
  pick: (cb)=>
    filepicker.pick (InkBlob)=>
      cb InkBlob
  pickLogo: =>
    @pick (InkBlob)=>
      @scope.job.logo = InkBlob
      @save @scope.job
  pickPicture: =>
    @pick (InkBlob)=>
      @scope.job.picture = InkBlob
      @save @scope.job
  pickBadge: =>
    @scope.job.badges?=[]
    filepicker.pickMultiple (InkBlobs)=>
      for InkBlob in InkBlobs
        @scope.job.badges.push InkBlob
      @save @scope.job
  removeBadge: (cBadge)=>
    for badge,i in @scope.job.badges
      if cBadge and badge and cBadge.url == badge.url
        @scope.job.badges.splice i,1
        @save @scope.job
angular.module('simpleannotateApp').controller('JobDescCtrl', JobDescCtrl)

'use strict'

angular.module('simplecareersApp')
  .controller 'IntroPageCtrl', ($scope,$location) ->
    # Called to navigate to the main app
    startApp = ->
      $location.path "/main"
  
      # Set a flag that we finished the tutorial
      window.localStorage["didTutorial"] = true
      return


    # Check if the user already did the tutorial and skip it if so
    if window.localStorage["didTutorial"] is "true"
      startApp()
      return

    # Move to the next slide
    $scope.next = ->
      $scope.$broadcast "slideBox.nextSlide"
      return


    # Our initial right buttons
    rightButtons = [
      content: "Next"
      type: "button-positive button-clear"
      tap: (e) ->
    
        # Go to the next slide on tap
        $scope.next()
        return
    ]

    # Our initial left buttons
    leftButtons = [
      content: "Skip"
      type: "button-positive button-clear"
      tap: (e) ->
    
        # Start the app on tap
        startApp()
        return
    ]

    # Bind the left and right buttons to the scope
    $scope.leftButtons = leftButtons
    $scope.rightButtons = rightButtons

    # Called each time the slide changes
    $scope.slideChanged = (index) ->
  
      # Check if we should update the left buttons
      if index > 0
    
        # If this is not the first slide, give it a back button
        $scope.leftButtons = [
          content: "Back"
          type: "button-positive button-clear"
          tap: (e) ->
        
            # Move to the previous slide
            $scope.$broadcast "slideBox.prevSlide"
            return
        ]
      else
    
        # This is the first slide, use the default left buttons
        $scope.leftButtons = leftButtons
  
      # If this is the last slide, set the right button to
      # move to the app
      if index is 2
        $scope.rightButtons = [
          content: "Start using MyApp"
          type: "button-positive button-clear"
          tap: (e) ->
            startApp()
            return
        ]
      else
    
        # Otherwise, use the default buttons
        $scope.rightButtons = rightButtons
      return

    return
  
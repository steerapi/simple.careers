Setup angular-phonegap
    
    phonegap create --name simplecareers --id careers.simple.app frontend
    cd frontend
    yo angular-ui-router
    npm install grunt-angular-phonegap --save-dev
    grunt phonegap:build
    phonegap run ios
    phonegap run android
    grunt phonegap:check
  
For web

    grunt server
    grunt build

For phonegap

    grunt phonegap:build:android
    grunt phonegap:build:ios
    phonegap remote login --username xxx --password xxx
    grunt phonegap:send

Generators
    
    yo angular-ui-router:controller myUser --coffee
    yo angular-ui-router:filter myFilter
    yo angular-ui-router:view myUser
    yo angular-ui-router:service myService --coffee
    yo angular-ui-router:decorator serviceName --coffee
    yo angular-ui-router:directive myDirective --coffee
    yo angular-ui-router:route myroute
    
"use strict"

async = require "async"
mongoose = require("mongoose")
User = mongoose.model("user")
Job = mongoose.model("Job")
###
Populate database with sample application data
###

# jobs = [
#   {
#     _id: "5346089a8d8b16020041c31b"
#     companyname: "Dyn"
#     companytagline: "The Core of Internet Performance"
#     jobtagline: "Dyn is seeking a Software Engineer to become part of a fast paced team which is focused on creating and maintaining world wide scalable infrastructure projects. This individual will be a member of the Engineering organization reporting to a Manager within Platform Engineering. This person will work with other team members and assist the Infrastructure squad with developing service oriented platforms for the processing of requests, the insertion and retrieval of data, and high performance long running processes."
#     location: "NH"
#     position: "Software Engineer"
#     type: "Full-Time"
#     updatedAt: "2014-04-10T08:20:06.848Z"
#     createdAt: "2014-04-10T02:57:30.485Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/MEPtKIGlR3ai4HLIso7M"
#         _id: "53460a428d8b16020041c32d"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/pEdpo5kQOiXBFWa8RqqM"
#         _id: "53460a428d8b16020041c331"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/h93Xwl9TZa2bla96OwAg"
#         _id: "53460a428d8b16020041c32e"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/Aoj4qdjShmX2Gkyysvra"
#         _id: "53460a428d8b16020041c330"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/6xamrM33SIeYekivPWht"
#         _id: "53460a428d8b16020041c32f"
#       }
#     ]
#     logo:
#       filename: "dyn.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "4663"
#       url: "https://www.filepicker.io/api/file/4hUH6fD0TRKSARTY762x"
# 
#     picture:
#       filename: "dyn-engineer.gif"
#       isWriteable: true
#       mimetype: "image/gif"
#       size: "1077305"
#       url: "https://www.filepicker.io/api/file/Efv8tEmRsWrQHKHfNk63"
#   }
#   {
#     _id: "5346d1961f395302004f14a0"
#     companyname: "Formlabs"
#     companytagline: "Affordable high-res 3D printers."
#     jobtagline: "Work closely with Marketing and Customer Support to make sure all of our images are top-notch"
#     location: "Cambridge"
#     position: "Design Internship"
#     type: "Internship"
#     updatedAt: "2014-04-12T20:11:10.331Z"
#     createdAt: "2014-04-10T17:15:02.814Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/D0rydeLQe2WRVhTakbgX"
#         filename: "CSS.png"
#         mimetype: "image/png"
#         size: "8748"
#         _id: "534998a2a696d802005caaa5"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/iearNSRoQGmjLv2vaxIm"
#         filename: "HTML.png"
#         mimetype: "image/png"
#         size: "6655"
#         _id: "534998a2a696d802005caaa4"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/LUvwIbS56ExHEMT8P73g"
#         filename: "Photoshop_Foundations.png"
#         mimetype: "image/png"
#         size: "8505"
#         _id: "534998a2a696d802005caaa3"
#       }
#     ]
#     logo:
#       filename: "Formlabs.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "18535"
#       url: "https://www.filepicker.io/api/file/j2W9ryGT5ucOsmB7G3FG"
# 
#     picture:
#       filename: "Formlabs.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "110223"
#       url: "https://www.filepicker.io/api/file/ZTaC5bjoQ6O0DZbo1C9b"
#   }
#   {
#     _id: "5346d1a41f395302004f14a1"
#     companyname: "Formlabs"
#     companytagline: "Affordable high-res 3D printers."
#     jobtagline: "Understand computational geometry algorithms with a strong math background."
#     location: "Cambridge"
#     position: "Software Algorithms"
#     type: "Internship"
#     updatedAt: "2014-04-12T20:10:53.397Z"
#     createdAt: "2014-04-10T17:15:16.531Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/djfdL3acTTGlDPIRYmoD"
#         filename: "C.png"
#         mimetype: "image/png"
#         size: "3011"
#         _id: "53499dcda696d802005caab6"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/GdvXhRWdQ1KTT5DqypGT"
#         filename: "Python.png"
#         mimetype: "image/png"
#         size: "3797"
#         _id: "53499dcda696d802005caab5"
#       }
#     ]
#     logo:
#       filename: "Formlabs.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "18535"
#       url: "https://www.filepicker.io/api/file/tseNK1cmRIGcjCNfwuBr"
# 
#     picture:
#       filename: "Formlabs 2.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "397864"
#       url: "https://www.filepicker.io/api/file/o1x1G3ffTIi9ldcSKPe3"
#   }
#   {
#     _id: "5346d1ab1f395302004f14a2"
#     companyname: "Formlabs"
#     companytagline: "Affordable high-res 3D printers"
#     jobtagline: "Developing C++ desktop software"
#     location: "Boston"
#     position: "Desktop Software Intern"
#     type: "Internship"
#     updatedAt: "2014-04-12T20:11:01.634Z"
#     createdAt: "2014-04-10T17:15:23.907Z"
#     badges: [
#       url: "https://www.filepicker.io/api/file/EUHUcOgR0eSitEixFiCk"
#       filename: "C.png"
#       mimetype: "image/png"
#       size: "3011"
#       _id: "53499dd5a696d802005caab7"
#     ]
#     logo:
#       filename: "Formlabs.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "18535"
#       url: "https://www.filepicker.io/api/file/34MXOqaReqisieCTqSkb"
# 
#     picture:
#       filename: "Formlabs 3.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "130866"
#       url: "https://www.filepicker.io/api/file/gEKlsRdSI2kYlFtWQgdp"
#   }
#   {
#     _id: "53499c80a696d802005caaab"
#     companyname: "Formlabs"
#     companytagline: "Affordable high-res 3D printers"
#     jobtagline: "A system thinker to make backend tools work together, develop maintainable and scalable web services"
#     location: "Boston"
#     position: "Full stack Developer (Backend)"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:10:38.138Z"
#     createdAt: "2014-04-12T20:05:20.529Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/dSXYDFEMSxKgLzwWdAx3"
#         filename: "Python.png"
#         mimetype: "image/png"
#         size: "3797"
#         _id: "53499dbea696d802005caab4"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/PJLIIYpFS86AXlN3YBdE"
#         filename: "ipad_default_2x_PHP.png"
#         mimetype: "image/png"
#         size: "22672"
#         _id: "53499dbea696d802005caab3"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/pgkae51DTdm2LiAnzE2J"
#         filename: "Ruby_Foundations.png"
#         mimetype: "image/png"
#         size: "56865"
#         _id: "53499dbea696d802005caab2"
#       }
#     ]
#     logo:
#       filename: "Formlabs.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "18535"
#       url: "https://www.filepicker.io/api/file/9gyQXAZTvKRqyaEZM3lN"
# 
#     picture:
#       filename: "Formlabs 4.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "58271"
#       url: "https://www.filepicker.io/api/file/jjmYn1fQSO8WcEyGm1yo"
#   }
#   {
#     _id: "53499de4a696d802005caab8"
#     companyname: "PubGet"
#     companytagline: "Scientific papers search engine"
#     jobtagline: "Configuring servers, developing, testing and responding when there are problems"
#     location: "South Boston"
#     position: "Software Engineer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:15:06.795Z"
#     createdAt: "2014-04-12T20:11:16.157Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/sy4i9VAS3ODeSESatjw8"
#         filename: "Ruby_Foundations.png"
#         mimetype: "image/png"
#         size: "56865"
#         _id: "53499ecaa696d802005caabb"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/OvPSuXVPQ7KN7sIdWNEK"
#         filename: "badges_DD_Git_Stage2.png"
#         mimetype: "image/png"
#         size: "7460"
#         _id: "53499ecaa696d802005caaba"
#       }
#     ]
#     logo:
#       filename: "PubGet.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "25938"
#       url: "https://www.filepicker.io/api/file/rpYa1qxRjyOJPWhdpASl"
# 
#     picture:
#       filename: "PubGet.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "125838"
#       url: "https://www.filepicker.io/api/file/ZFICmwfnS6mfwMoZRtl9"
#   }
#   {
#     _id: "53499f75a696d802005caabc"
#     companyname: "Aquto"
#     companytagline: "Ad platform that gives consumers mobile data credit for engaging with brands"
#     jobtagline: "Scala enthusiast. Implement a cutting edge, high performance, backend system"
#     location: "Boston"
#     position: "Backend/Scala Engineer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:21:22.737Z"
#     createdAt: "2014-04-12T20:17:57.431Z"
#     badges: [
#       url: "https://www.filepicker.io/api/file/dUswSWPRB2qc1IUZHEHD"
#       filename: "Java.png"
#       mimetype: "image/png"
#       size: "4585"
#       _id: "5349a042a696d802005caabd"
#     ]
#     logo:
#       filename: "Aquto.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "51251"
#       url: "https://www.filepicker.io/api/file/s2EFtIMYSaWtPUtqGfnz"
# 
#     picture:
#       filename: "Aquto.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "381041"
#       url: "https://www.filepicker.io/api/file/ThtAaDPpQ5y5oXifiVJW"
#   }
#   {
#     _id: "5349a070a696d802005caabe"
#     companyname: "Celtra"
#     companytagline: "Create, traffic and track quality rich media mobile ads"
#     jobtagline: "Work on backend data services infrastructure to turn mountains of data into actionable insights for ad builders and campaign planners"
#     location: "San Francisco"
#     position: "Software Engineer - Analytics"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:30:54.943Z"
#     createdAt: "2014-04-12T20:22:08.665Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/BZL7vIysR7SjXlwaE24S"
#         filename: "Java (1).png"
#         mimetype: "image/png"
#         size: "4585"
#         _id: "5349a27ea696d802005caac1"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/zpfes7vGS6twRdsffjkk"
#         filename: "C (1).png"
#         mimetype: "image/png"
#         size: "3011"
#         _id: "5349a27ea696d802005caac0"
#       }
#     ]
#     logo:
#       filename: "Celtra.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "13508"
#       url: "https://www.filepicker.io/api/file/yu1S4eIpSByjqiVrb0Aw"
# 
#     picture:
#       filename: "Celtra.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "557135"
#       url: "https://www.filepicker.io/api/file/hAD8VpVlTbOjKk4d8kw0"
#   }
#   {
#     _id: "5349a2e8a696d802005caac2"
#     companyname: "Clypd"
#     companytagline: "Targeted advertising on interactive TV series"
#     jobtagline: "Generalist, moving between full-stack web development on our front-end UI and building out highly scalable API's for our back-end system"
#     location: "Cambridge"
#     position: "Software Engineer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:45:45.719Z"
#     createdAt: "2014-04-12T20:32:40.281Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/LbTN2udYQNSPVNCvQIJE"
#         filename: "Ruby_Foundations.png"
#         mimetype: "image/png"
#         size: "56865"
#         _id: "5349a5f9a696d802005caaca"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/6IMNxZeaRxpYpOeJ8Jlg"
#         filename: "JavaScript.png"
#         mimetype: "image/png"
#         size: "7674"
#         _id: "5349a5f9a696d802005caac9"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/Sganv8a4SRieJfPdXDhe"
#         filename: "badges_JavaScript_jQueryBasics_Stage1.png"
#         mimetype: "image/png"
#         size: "9302"
#         _id: "5349a5f9a696d802005caac8"
#       }
#     ]
#     logo:
#       filename: "Clypd.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "12742"
#       url: "https://www.filepicker.io/api/file/1fJXurLRNsHblDzK7IUQ"
# 
#     picture:
#       filename: "Clypd.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "245915"
#       url: "https://www.filepicker.io/api/file/wljDVpATzGsMpc3JgJgP"
#   }
#   {
#     _id: "5349a40aa696d802005caac6"
#     companyname: "Swoop"
#     companytagline: "Make ads that don’t suck"
#     jobtagline: "Full stack, mobile developer, experienced with building client-side web applications"
#     location: "Cambridge"
#     position: "JavaScript Engineer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:47:58.195Z"
#     createdAt: "2014-04-12T20:37:30.063Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/NYtOML7ZRnOBqQN3Yxxr"
#         filename: "ipad_default_2x_JavaScript.png"
#         mimetype: "image/png"
#         size: "12020"
#         _id: "5349a67ea696d802005caad3"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/eM24EmZvQ6e3jdnXxZSY"
#         filename: "badges_api.png"
#         mimetype: "image/png"
#         size: "12707"
#         _id: "5349a67ea696d802005caad2"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/Z7Khho0aQ3KNjOKtj1OL"
#         filename: "bagdes_html_howtobuildawebsite_stage03.png"
#         mimetype: "image/png"
#         size: "6936"
#         _id: "5349a67ea696d802005caad1"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/bvARhS74Qv29p9cXo7hv"
#         filename: "CSS.png"
#         mimetype: "image/png"
#         size: "8748"
#         _id: "5349a67ea696d802005caad0"
#       }
#     ]
#     logo:
#       filename: "Swoop.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "19802"
#       url: "https://www.filepicker.io/api/file/s8eDxaqTECAjqQFBLQZP"
# 
#     picture:
#       filename: "Swoop.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "283928"
#       url: "https://www.filepicker.io/api/file/aaWw0nlRZSJlPOwxMMRS"
#   }
#   {
#     _id: "5349a684a696d802005caad4"
#     companyname: "Swoop"
#     companytagline: "Make ads that don’t suck"
#     jobtagline: "Design and develop significant new functionality using Ruby 2.0, Rails 4, AngularJS, MongoDB and Redis"
#     location: "Cambridge"
#     position: "Full Stack Ruby/Rails Engineer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:51:36.742Z"
#     createdAt: "2014-04-12T20:48:04.816Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/E48SeHODS6OEUlWCW7TF"
#         filename: "Ruby_Foundations.png"
#         mimetype: "image/png"
#         size: "56865"
#         _id: "5349a758a696d802005caad7"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/i2jzyjknTiiCObFeAkYs"
#         filename: "REST.png"
#         mimetype: "image/png"
#         size: "3064"
#         _id: "5349a758a696d802005caad6"
#       }
#     ]
#     logo:
#       filename: "Swoop.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "19802"
#       url: "https://www.filepicker.io/api/file/GsGFC4QcRUXKCRXR1HLw"
# 
#     picture:
#       filename: "Swoop 2.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "61416"
#       url: "https://www.filepicker.io/api/file/KlwKXQkTwuUZuZimJT3v"
#   }
#   {
#     _id: "5349a858a696d802005caad8"
#     companyname: "Swoop"
#     companytagline: "Make ads that don’t suck"
#     jobtagline: "Versatile, adaptable, and comfortable with straddling the strict, type-safe environment of server-side Java and the fast, loose world of semi-structured data for the Web."
#     location: "Cambridge"
#     position: "Java Engineer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T20:58:33.662Z"
#     createdAt: "2014-04-12T20:55:52.392Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/WjB6YqbGTWYhjU1SkUVT"
#         filename: "Java (2).png"
#         mimetype: "image/png"
#         size: "4585"
#         _id: "5349a8f9a696d802005caade"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/P2p79n9NSkyhDzlIGRxR"
#         filename: "iOS_Advanced_API.png"
#         mimetype: "image/png"
#         size: "7840"
#         _id: "5349a8f9a696d802005caadd"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/98xtuqjLSimxbjPK2pBR"
#         filename: "REST.png"
#         mimetype: "image/png"
#         size: "3064"
#         _id: "5349a8f9a696d802005caadc"
#       }
#     ]
#     logo:
#       filename: "Swoop.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "19802"
#       url: "https://www.filepicker.io/api/file/NrcKipyCSPKaNs7w8voW"
# 
#     picture:
#       filename: "Swoop 3.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "96558"
#       url: "https://www.filepicker.io/api/file/n3PgoDRqSQ4LBcloIUAI"
#   }
#   {
#     _id: "5349a8fea696d802005caadf"
#     companyname: "Artaic"
#     companytagline: "Robot-produced decorative tile mosaics"
#     jobtagline: "Develop a new e-commerce site with a mass-customization configurator application, as well as improving our current web properties"
#     location: "Boston"
#     position: "Front End Developer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T21:03:43.767Z"
#     createdAt: "2014-04-12T20:58:38.206Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/fpkrov7TWSsyhMIO9glw"
#         filename: "ipad_default_2x_PHP.png"
#         mimetype: "image/png"
#         size: "22672"
#         _id: "5349aa2fa696d802005caaf4"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/KYAjor3RECOI4JtFGEJX"
#         filename: "ipad_default_2x_CSS3.png"
#         mimetype: "image/png"
#         size: "14089"
#         _id: "5349aa2fa696d802005caaf3"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/u4ywUe0mQWuTXsm7kZup"
#         filename: "badges_JavaScript_jQueryBasics_Stage1.png"
#         mimetype: "image/png"
#         size: "9302"
#         _id: "5349aa2fa696d802005caaf2"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/P0wkPCImQOuPoEhgAcdT"
#         filename: "ipad_default_2x_JavaScript.png"
#         mimetype: "image/png"
#         size: "12020"
#         _id: "5349aa2fa696d802005caaf1"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/bnFPyOQwT0WYpkAJZtru"
#         filename: "bagdes_html_howtobuildawebsite_stage03.png"
#         mimetype: "image/png"
#         size: "6936"
#         _id: "5349aa2fa696d802005caaf0"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/9yPMtpGhQAynBic4IEcp"
#         filename: "ipad_default_2x_Photoshop_Foundations.png"
#         mimetype: "image/png"
#         size: "26033"
#         _id: "5349aa2fa696d802005caaef"
#       }
#     ]
#     logo:
#       filename: "Artaic.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "6543"
#       url: "https://www.filepicker.io/api/file/EXjlrD3FSTWo8qWqlzqw"
# 
#     picture:
#       filename: "Artaic.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "59738"
#       url: "https://www.filepicker.io/api/file/4crVBHbWQEmnNPK03uZq"
#   }
#   {
#     _id: "5349aa3aa696d802005caaf5"
#     companyname: "Iseecars"
#     companytagline: "Web development for a website that makes a large volme of data accessible to millions of users in a friendly and innovative way, backend algorithms including machine learning/feedback loops, and database development"
#     jobtagline: "Web development for a website that makes a large volme of data accessible to millions of users in a friendly and innovative way, backend algorithms including machine learning/feedback loops, and database development"
#     location: "Woburn"
#     position: "Java Web Developer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T21:08:21.872Z"
#     createdAt: "2014-04-12T21:03:54.303Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/37MpK9CKRwWVWAOj3qVj"
#         filename: "ipad_default_2x_JavaScript.png"
#         mimetype: "image/png"
#         size: "12020"
#         _id: "5349ab45a696d802005caafb"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/FlAsCpyJQouq9X0wI0xI"
#         filename: "Java (3).png"
#         mimetype: "image/png"
#         size: "4585"
#         _id: "5349ab45a696d802005caafa"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/Lyq9udXUQbm7DLOu9FXD"
#         filename: "badges_WebsiteIsland1_Stage3.png"
#         mimetype: "image/png"
#         size: "6257"
#         _id: "5349ab45a696d802005caaf9"
#       }
#     ]
#     logo:
#       filename: "Iseecars.jpeg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "5284"
#       url: "https://www.filepicker.io/api/file/Kk3rVsTJSxur5MuuPRF5"
# 
#     picture:
#       filename: "Iseecars.jpg"
#       isWriteable: true
#       mimetype: "image/jpeg"
#       size: "59100"
#       url: "https://www.filepicker.io/api/file/yqRu7KuVTqCjq65lVnof"
#   }
#   {
#     _id: "5349ab4ea696d802005caafc"
#     companyname: "RapidMiner"
#     companytagline: "Predictive analytics for business analysts"
#     jobtagline: "Experience with designing and implementing enterprise scale web solutions using Java based technologies; opportunity to influence industry trends around Big Data analytics"
#     location: "Cambridge"
#     position: "Java Web Developer"
#     type: "Full Time"
#     updatedAt: "2014-04-12T21:13:14.899Z"
#     createdAt: "2014-04-12T21:08:30.997Z"
#     badges: [
#       {
#         url: "https://www.filepicker.io/api/file/ppMI3ZcpSSav40d1oaH3"
#         filename: "HTML.png"
#         mimetype: "image/png"
#         size: "6655"
#         _id: "5349ac6aa696d802005cab0b"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/7rKFnxAQ6eNcQRDpE6wI"
#         filename: "CSS3.png"
#         mimetype: "image/png"
#         size: "10514"
#         _id: "5349ac6aa696d802005cab0a"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/sWQSUHBbQVuqYNGlNCpI"
#         filename: "ipad_default_2x_JavaScript.png"
#         mimetype: "image/png"
#         size: "12020"
#         _id: "5349ac6aa696d802005cab09"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/6gGeEjXLSuWdBRY3SpgF"
#         filename: "badges_JavaScript_jQueryBasics_Stage1.png"
#         mimetype: "image/png"
#         size: "9302"
#         _id: "5349ac6aa696d802005cab08"
#       }
#       {
#         url: "https://www.filepicker.io/api/file/5C1lwG4wTAC2nULo2oZm"
#         filename: "REST (1).png"
#         mimetype: "image/png"
#         size: "3064"
#         _id: "5349ac6aa696d802005cab07"
#       }
#     ]
#     logo:
#       filename: "Rapidminer.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "42497"
#       url: "https://www.filepicker.io/api/file/mz8ef2PwToCBC0fZo0Gw"
# 
#     picture:
#       filename: "RapidMiner.png"
#       isWriteable: true
#       mimetype: "image/png"
#       size: "146930"
#       url: "https://www.filepicker.io/api/file/cbpN0vhQbKc9npNoYjMW"
#   }
# ]
# 
# #Clear old things, then add things in
# Job.find({}).remove ->
#   async.each jobs, (job,cb)->
#     Job.create job, cb
#   , ->
#     console.log "finished populating jobs"
#     return
#   return
# 
# # Clear old users, then add a default user
# User.find({}).remove ->
#   User.create
#     provider: "local"
#     name: "Test User"
#     email: "test@test.com"
#     password: "test"
#   , ->
#     console.log "finished populating users"
#     return
# 
#   return

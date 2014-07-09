
##express-coffee-mongo-boilerplate by Hans Gill

ExpressJS CoffeeScript Mongodb Boilerplate code. This repo lets you get up and running in no time and focus on building a node based app using coffeescript, mongo and expressJS

##Configuration

Config.json is the system wide settings. If you have more than one environment then that environment file will supercede the same setting in config.json

To make changes to configuration you can update two files.

    env/{environment}-conf.json or config.json

At the minimum make changes to the following two properties in config.json or {environment}-conf.json (environment is recommended)

1) "app_id" : "{Name of your App}"*

2) "port" : {port you want the server to run on}*

* Make sure the mongo property is pointing to the correct server*


##Starting the server

1) Replace boilerplate text in Makefile, with name of project (nospaces allowed)
    
    Project = YourprojectNameHere (no spaces allowed)

2) Install node packages managed by npm via package.json and front-end code via brunch (please ensure you have brunch already installed on your server)
  
    make install

3) Build the project and start watching the files for changes

    make watch

4) Open up a new console tab type
    
    nodemon bin/server

  * to run in difference environment just pass NODE_ENV={environment}.
  
    Ex: NODE_ENV=production nodemon bin/server

  This will load properties from config.json followed by production-conf.json. *Any properties with similar names in {environment}-config.json will take precedence over config.json*

## Enable Basic Auth

Go to {env}-conf.json file and set the following flag
    
    "enableBasicAuth" : true

By enabling basic auth, the server sets up the route below. The post expect username / password as basic authentication headers.
    
    POST /auth/login

Response can be whatever you want it to be. If you are looking to build RESTfull API, I suggest you lookup the user and send back the token associated with the user. Also make sure you enable the protection of API's (next section).

## Enable Protection of API's

Go to {env}-conf.json file and set the following flag
    
    "protectAPI" : true

Once enabled, all the /api/* routes expect to get the header below in the request. Token can be the value you sent the user during successful POST to /auth/login
    
    Authentication : Bearer <token>


## License 

The MIT License (MIT)

Copyright (c) 2014 Hans Gill

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
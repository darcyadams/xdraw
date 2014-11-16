express = require 'express'
favicon = require 'serve-favicon'
errorhandler = require 'errorhandler'
http = require 'http'
https = require 'https'
httpProxy = require 'http-proxy'
path = require 'path'

# Proxy setup
proxyTarget = require './server/proxy_target'
proxyPaths = require './server/proxy_paths'


proxyConfig =
  changeOrigin: true
  target: proxyTarget

# Check for HTTPS
if proxyTarget.https
  proxyConfig.agent = https.globalAgent
  proxyConfig.headers =
    host: proxyTarget.host

# Create the proxy server
proxy = httpProxy.createProxyServer(proxyConfig)

# Proxy error handling
proxy.on('error', ->
  console.log('proxyError', arguments[0])
)

# Proxy middleware
proxyHandler = (req, res) ->
  proxy.web(req, res)

app = express()
server = http.createServer(app)

# Defaults
app.set('port', process.env.PORT || 8888)
app.set('views', __dirname + '/server/views')
app.set('view engine', 'hbs')
app.disable('x-powered-by')
#app.use(favicon())  # TODO where is our favicon?!?

# Setup Custom Headers
app.use((req, res, next) ->
  res.set('X-UA-Compatible', 'IE=edge,chrome=1')
  next()
)


env = app.settings.env

# ------------------- DEVELOPMENT ENVIRONMENT SETTINGS ---------------------------
if env is 'development'

  # Mock API 
  require('./fixtures/')(app)

  # Fixes SSL Cert Issue `Unable To Verify Leaf Signature`
  #process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0'

  # Proxy the API
  proxyPaths(app, proxyHandler)
  
  # Load all static files under the route /assets
  app.use('/client', express['static'](path.join(__dirname, 'client')))

  app.use(errorhandler())



# ------------------- PRODUCTION ENVIRONMENT SETTINGS ---------------------------
if env is 'production'
  
  # Load all static files under the route /build
  app.use('/build', express['static'](path.join(__dirname, 'build')))


  

# Link up the routes
require('./server/routes')(app, server)


# Start the App
server.listen(app.get('port'), () ->
  console.log(
    """
      ████████████████████████████████████████████████████████████████████████████████████████
      Application Started...
    """
  )
  #console.log(cl_splash[Math.floor(Math.random() * (cl_splash.length - 1))])
  console.log(
    """
      ________________________________________________________________________________________
      
      mode: #{app.settings.env}
      port: #{app.get('port')}
      dev proxy target: #{proxyTarget.host}

      ████████████████████████████████████████████████████████████████████████████████████████
    """
  )             
)
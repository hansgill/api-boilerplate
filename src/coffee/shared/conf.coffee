fs      = require "fs"
nconf   = require "nconf"
colors  = require "colors"

# Load global config
file = __dirname + "/../../config.json"
console.log "Loading global config file #{file}...".blue
nconf.file "global", file

console.log "Loading argv and env configuration...".blue
nconf.argv().env()

# Default to localhost env
nconf.set("NODE_ENV", "localhost") and console.log "No node env found, setting to localhost...".blue unless nconf.get "NODE_ENV"

# Get enviornment and default to local
ENV = nconf.get "NODE_ENV" or "localhost"

# Optionally set a per environment configuration file e.g. production.json
file = (nconf.get "f") ? __dirname + "/../../env/#{ENV}-conf.json"
console.log "Loading file #{file} if available...".blue
nconf.file "enviornment", file

console.log "Configuration initialized.".blue
module.exports = nconf
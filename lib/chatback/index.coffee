path  = require 'path'
fs    = require 'fs'


file  = process.argv[0] # Facebook messages file
you   = process.argv[1] # Your name
other = process.argv[2] # Other's name

console.log "Analyzing " + file + " for message statstics between you (" + you + ") and " + other

# pwfile = fs.readFileSync h + '/.pw'
# pwfile = pwfile.toString()

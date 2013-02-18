path   = require 'path'
fs     = require 'fs'
jQuery = require 'jquery'


file  = process.argv[2] # Facebook messages file
you   = process.argv[3] # Your name
other = process.argv[4] # Other's name

console.log "Analyzing " + file + " for message statstics between:"
console.log  you + " and " + other +  "."

lines  = fs.readFileSync(file).toString().split('\n')

console.log "File has " + lines.length + " lines."
console.log "Going to find the right conversation."

_thread = false
thread = false
messages = []
found = false

for line in lines
  if line.indexOf('<div class="thread">') == 0
    found = false
    header = ''
    for i in [_i+1.._i+7]
      header += lines[i] + '\n'

    header = jQuery(header)

    users = []
    header.find('.profile').each ->
      users.push jQuery(this).text()

    _thread =
      date: new Date(header.find('.time').attr('title'))
      users: users

    if _thread.users.length == 2 
      if ((_thread.users[0] == you and _thread.users[1] == other) or (_thread.users[0] == other and _thread.users[1] == you))
        thread = _thread
        found = true

  if found
    if line.indexOf('<div class="message">') == 0
      message =
        from: lines[_i+1].replace('<div class="from"><span class="profile fn">', '').replace('</span></div>', '')
        date: new Date(lines[_i+2].substr(36, 24))
        body: lines[_i+4].replace('<BR>', '')      

      messages.push message

if thread
  console.log 'Conversation found, analyzing ' + messages.length + ' messages.'

  stats =
    messages_per_month: []
    messages_per_year: {}
    messages_per_weekday: []
    messages_per_user: {}
    words_per_user: {}

  thread.words = 0

  for message in messages
    words = message.body.split(' ').length
    thread.words += words

    # Messages per month logic
    if stats.messages_per_month[message.date.getMonth()] >= 0
      stats.messages_per_month[message.date.getMonth()]++
    else
      stats.messages_per_month[message.date.getMonth()] = 0

    # Messages per year logic
    if stats.messages_per_year[message.date.getFullYear()] >= 0
      stats.messages_per_year[message.date.getFullYear()]++
    else
      stats.messages_per_year[message.date.getFullYear()] = 0

    # Messages per weakday logic
    if stats.messages_per_weekday[message.date.getDay()] >= 0
      stats.messages_per_weekday[message.date.getDay()]++
    else
      stats.messages_per_weekday[message.date.getDay()] = 0
    
    # Messages per user logic
    if stats.messages_per_user[message.from] >= 0
      stats.messages_per_user[message.from]++
    else
      stats.messages_per_user[message.from] = 0
    
    # Words per user logic
    if stats.words_per_user[message.from] >= 0
      stats.words_per_user[message.from] += words
    else
      stats.words_per_user[message.from] = words


  thread.stats = stats

  console.log thread


else
 console.log 'Conversation not found.'


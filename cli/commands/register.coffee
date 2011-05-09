#
# Handles the new user registration
#
# Copyright (C) 2011 Nikolay Nemshilov
#

stdin  = process.stdin
stdout = process.stdout

# a little helper to ask the user for data
ask_for = (intro, format, callback) ->
  stdin.resume()

  stdout.write intro + " » ".grey
  stdin.once 'data', (data) ->
    data = data.toString().trim()

    if format.test(data)
      callback(data)
    else
      stdout.write "It should match: ".red + format.toString().yellow + "\n"
      ask_for intro, format, callback


exports.init = (args) ->
  email_re    = /^[a-z0-9\-\.]+@[a-z0-9\-\.]+\.[a-z]{2,4}$/i
  username_re = /^[a-z0-9][a-z0-9\-\_]+[a-z0-9]$/i
  realname_re = /^[a-z0-9 ]+$/i

  stdout.write(
    "New user registration:\n" +
    "Press Ctrl+D if you wanna stop\n\n"
  )

  ask_for "Email", email_re, (email) ->
    ask_for "Username", username_re, (username) ->
      ask_for "Realname", realname_re, (realname) ->
        stdout.write """

        So, your name is: #{realname}
        your email is:    #{email}
        and username is:  #{username}

        Proceed? (#{"y/n".yellow}) #{"» ".grey}
        """

        stdin.once 'data', (data) ->
          if data.toString().toLowerCase().trim() is 'y'
            stdout.write "\nConnecting to the server...\n"

          process.exit()


exports.help = (args) ->
  """
  Registers a new user on the lovely.io site

  Usage:
      lovely register

  It will talk you through it

  """
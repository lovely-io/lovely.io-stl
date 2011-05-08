/**
 * Handles the new user registration
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

var stdin = process.stdin, stdout = process.stdout;

function ask_for(intro, format, callback) {
  stdin.resume();

  stdout.write(intro + " » ".grey);
  stdin.once('data', function(data) {
    data = data.toString().trim();

    if (format.test(data)) {
      callback(data);
    } else {
      stdout.write("It should match: ".red + format.toString().yellow + "\n");
      ask_for(intro, format, callback);
    }
  });
}

exports.init = function(args) {
  var email_re    = /^[a-z0-9\-\.]+@[a-z0-9\-\.]+\.[a-z]{2,4}$/i;
  var username_re = /^[a-z0-9][a-z0-9\-\_]+[a-z0-9]$/i;
  var realname_re = /^[a-z0-9 ]+$/i;

  stdout.write(
    "New user registration:\n" +
    "Press Ctrl+D if you wanna stop\n\n"
  );

  ask_for("Email", email_re, function(email) {
    ask_for("Username", username_re, function(username) {
      ask_for("Realname", realname_re, function(realname) {
        stdout.write(
          "\nSo, your name is: "+ realname +
          "\nyour email is:    "+ email    +
          "\nand username is:  "+ username +
          "\n\nProceed? ("+ "y/n".yellow + ")" + " » ".grey
        );

        stdin.once('data', function(data) {
          if (data.toString().toLowerCase().trim() == 'y') {
            stdout.write(
              "\nConnecting to the server..."
            );
          }

          process.exit();
        });
      });
    });
  });
};

exports.help = function(args) {
  console.log(
    "Registers a new user on the lovely.io site\n\n" +
    "Usage: \n    lovely register\n\n" +
    "It will talk you through it"
  );
};
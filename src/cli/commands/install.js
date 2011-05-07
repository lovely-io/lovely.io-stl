/**
 * Packages installing command
 *
 * Copyright (C) 2011 Nikolay Nemshilov
 */

exports.init = function(args) {

};


exports.help = function(args) {
  console.log(
    "Install a lovely package\n\n" +
    "Usage: \n    lovely install <package-name>\n\n" +

    "To install your own package locally, run:\n" +
    "    lovely install\n" +
    "from your project root directory"
  );
};
#
# The front-controler for the application
#
# Copyright (C) 2011 Nikolay Nemshilov
#

from google.appengine.ext.webapp      import WSGIApplication
from google.appengine.ext.webapp.util import run_wsgi_app

from app.controllers.pages_controller import PagesController


application = WSGIApplication([
    ('/.*', PagesController),
], debug=True)


def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()
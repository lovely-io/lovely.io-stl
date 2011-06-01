#
# All sorts of static pages controller
#
# Copyright (C) 2011 Nikolay Nemshilov
#
import os

from application_controller import ApplicationController

CONTENT_TYPES = {
    'css' : 'text/css',
    'js'  : 'text/javascript',
    'txt' : 'text/plain',
    'ico' : 'image/ico'
}

class PagesController(ApplicationController):
    resource = '/' # it works in the root resource

    def index(self):
        """ Just render the landing page"""
        self.render('index')


    def show(self):
        """ Handles the static pages requests """

        if os.path.exists(self.public_path + self.request.path):
            self.send_static()
        elif os.path.exists(self.views_path + self.params['id'] + '.html'):
            self.render(self.params['id'])
        else:
            self.render('404', {'status': 404})


    def send_static(self):
        """ Handles the static content serving """

        file = self.public_path + self.request.path
        type = file.split('.')
        type = type[len(type) - 1]
        type = CONTENT_TYPES[type] or 'text/html'

        self.response.headers['Content-Type'] = type
        self.response.out.write(open(file, 'r').read())
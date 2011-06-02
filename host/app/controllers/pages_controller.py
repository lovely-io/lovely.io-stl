#
# All sorts of static pages controller
#
# Copyright (C) 2011 Nikolay Nemshilov
#
from application_controller import ApplicationController

class PagesController(ApplicationController):
    resource = '/' # it works in the root resource

    def index(self):
        """ Just render the landing page"""
        self.render('index')


    def show(self):
        """ Handles the static pages requests """

        if self.template_exists(self.params['id']):
            self.render(self.params['id'])
        else:
            self.render('404', {'status': 404})



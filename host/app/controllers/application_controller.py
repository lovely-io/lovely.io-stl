#
# The abstract application controller,
#
# basically it wraps all the google appengine mumbo-jumo
# into a nice RESTful controller, like we all used to have
# in our beloved Rails
#
# Copyright (C) 2011 Nikolay Nemshilov
#
import os

from google.appengine.ext.webapp import RequestHandler, template


TEMPLATES_PATH = os.path.join(os.path.dirname(__file__), '..', 'views')
PUBLIC_PATH    = os.path.join(os.path.dirname(__file__), '..', '..', 'public')


class ApplicationController(RequestHandler):

    def __init__(self, **kwargs):
        """ Pre-extracting some RESTful configurations """
        self.__name__ = self.__class__.__name__.replace('Controller', '').lower()
        self.resource = self.__class__.resource or ('/' + self.__name__)

        self.views_path  = TEMPLATES_PATH + '/' + self.__name__ + '/'
        self.public_path = PUBLIC_PATH

        super(ApplicationController, self).__init__(**kwargs)

    def get(self):
        self.parse_params()

        if self.params.has_key('id'):
            if self.params['id'] == 'new':
                self.new()
            else:
                self.show()
        else:
            self.index()


    def post(self):
        self.parse_params()

        if self.params['_method'] == 'put':
            self.put()
        elif self.params['_method'] == 'delete':
            self.delete()
        else:
            self.create()


    def put(self):
        self.parse_params()
        self.update()

    def delete(self):
        self.parse_params()
        self.destroy()

# protected

    def render(self, path, values={}):
        """ Renders the template with given values """

        data = template.render(self.views_path + path + '.html', values)

        path = TEMPLATES_PATH + '/layouts/default.html'

        if values.has_key('status'):
            self.response.set_status(values['status'])

        if values.has_key('layout'):
            path = TEMPLATES_PATH + '/layouts/'+ values['layout'] + '.html'

        self.response.headers['Content-Type'] = 'text/html'
        self.response.out.write(template.render(path, {'content': data}))


    def parse_params(self):
        """ Pares out restful URL params """
        self.params = {}

        path = self.request.path
        path = path[len(self.resource) : len(path)]

        if len(path) > 0 and path[0] == '/':
            path = path[1 : len(path)]

        id = path.split('/')[0]

        if len(id) > 0:
            self.params['id'] = id
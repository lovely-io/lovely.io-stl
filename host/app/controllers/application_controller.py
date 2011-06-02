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
CONTENT_TYPES  = {
    'css' : 'text/css',
    'js'  : 'text/javascript',
    'txt' : 'text/plain',
    'ico' : 'image/ico'
}


class ApplicationController(RequestHandler):

    def __init__(self, **kwargs):
        """ Pre-extracting some RESTful configurations """
        self.__name__ = self.__class__.__name__.replace('Controller', '').lower()
        self.resource = self.__class__.resource or ('/' + self.__name__)

        self.views_path  = TEMPLATES_PATH + '/' + self.__name__ + '/'

        super(ApplicationController, self).__init__(**kwargs)


    def get(self):
        if self.request.path != '/' and os.path.exists(PUBLIC_PATH + self.request.path):
            self.send_static()
        else:
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


    # dummy RESTful methods
    def index(self):
        self.render('index')

    def new(self):
        self.render('new')

    def show(self):
        self.render('show')

    def edit(self):
        self.render('edit')

    def update(self):
        return None

    def destroy(self):
        return None

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

        format = path.split('.')
        if len(format) > 1:
            format = format[len(format) - 1]
            path   = path[0 : len(path) - len(format) - 1]

        self.params['format'] = format or 'html'

        if len(path) > 0:
            self.params['id'] = path


    def template_exists(self, name):
        """ Checks if the template exists """
        return os.path.exists(self.views_path + name + '.html')


    def send_static(self):
        """ Handles the static content serving """

        file = PUBLIC_PATH + self.request.path
        type = file.split('.')
        type = type[len(type) - 1]
        type = CONTENT_TYPES[type] or 'text/html'

        self.response.headers['Content-Type'] = type
        self.response.out.write(open(file, 'r').read())
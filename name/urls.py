
from django.conf.urls import patterns, include, url
urlpatterns = patterns('name.views',
    url(r'^$', 'main'),
    url(r'^(?P<gender>male|female)/$', 'names'),
    url(r'^desc/(?P<name_id>\d+)/$', 'description'),
)

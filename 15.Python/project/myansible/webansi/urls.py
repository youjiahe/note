from django.conf.urls import url
from . import views
urlpatterns=[
    url(r'^$',views.home,name='polls_index'),
    url(r'^addhosts/$',views.addhosts,name='polls_addhosts'),
    url(r'addmods/$', views.addmods,name='polls_addmods'),
    url(r'tasks/$',views.tasks,name='polls_tasks'),
]
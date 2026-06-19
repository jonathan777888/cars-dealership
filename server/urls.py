from django.contrib import admin
from django.urls import path, include
from djangoapp import views

urlpatterns = [
    path("", views.home_page),
    path("login-demo", views.demo_login),
    path("logout-demo", views.demo_logout),
    path("admin/", admin.site.urls),
    path("djangoapp/", include("djangoapp.urls")),
]

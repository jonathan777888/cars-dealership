from django.urls import path
from . import views

urlpatterns = [
    path("login", views.login_user),
    path("logout", views.logout_user),
    path("login_user", views.login_user),
    path("logout_user", views.logout_user),
    path("get_cars", views.get_cars),
    path("dealer/<int:dealer_id>", views.dealer_page),
    path("dealer/<int:dealer_id>/review", views.submit_review),
]

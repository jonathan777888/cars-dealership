from django.contrib import admin
from django.urls import path, include
from djangoapp import views

urlpatterns = [
    path("", views.home_page),
    path("login-demo", views.demo_login),
    path("logout-demo", views.demo_logout),
    path("admin/", admin.site.urls),
    path("djangoapp/", include("djangoapp.urls")),

    path("fetchDealers", views.get_all_dealers),
    path("fetchDealer/<int:dealer_id>", views.get_dealer),
    path("fetchDealers/<str:state>", views.get_dealers_by_state),
    path("fetchReviews/dealer/<int:dealer_id>", views.get_reviews),
    path("analyze/<str:text>", views.analyze),
]

from django.urls import path
from . import views

urlpatterns = [
    path("login_user", views.login_user),
    path("logout_user", views.logout_user),
    path("get_dealers", views.get_dealers),
    path("get_dealer/<int:dealer_id>", views.get_dealer_by_id),
    path("get_dealers/<str:state>", views.get_dealers_by_state),
    path("get_dealer_reviews/<int:dealer_id>", views.get_dealer_reviews),
    path("get_cars", views.get_cars),
    path("analyze_review_sentiments", views.analyze_review_sentiments),
    path("dealer/<int:dealer_id>", views.dealer_page),
    path("dealer/<int:dealer_id>/review", views.submit_review),
]

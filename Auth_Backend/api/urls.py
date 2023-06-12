from django.urls import path
from . import views

urlpatterns = [
    path('create_user/', views.create_user, name='create_user'),
    path('login/', views.login_view, name='login'),
    path('location_check/', views.location_check_view, name='location_check'),
    path('change_settings/', views.change_settings_view, name='change_settings'),
    path('get_mandatory_locations/', views.get_mandatory_locations_view, name='get_mandatory_locations'),
    path('add_mandatory_location/', views.add_mandatory_location_view, name='add_mandatory_location'),
]
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
# Create your models here.

class User(AbstractBaseUser):
    email = models.EmailField(unique=True)
    password = models.TextField()
    USERNAME_FIELD = 'email'
    # Use this function to add newest location.
    def add_location(self, latitude, longitude, date):
        UserLocation.objects.create(user=self, latitude=latitude, longitude=longitude, date=date)
        locations = self.locations.all()
        if len(locations) > 5:
            oldest_location = locations.order_by('date').first()
            oldest_location.delete()


class UserLocation(models.Model):
    user = models.ForeignKey(User, related_name='locations', on_delete=models.CASCADE)
    latitude = models.FloatField()
    longitude = models.FloatField()
    date = models.DateTimeField(default=timezone.now)
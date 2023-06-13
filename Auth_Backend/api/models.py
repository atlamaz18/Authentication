from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
# Create your models here.

class User(AbstractBaseUser):
    email = models.EmailField(unique=True)
    password = models.TextField()
    USERNAME_FIELD = 'email'
    mandatory_count = models.IntegerField(default=0)

    # Use this function to add newest location.
    def add_location(self, latitude, longitude, date):
        UserLocation.objects.create(user=self, latitude=latitude, longitude=longitude, date=date)
        locations = self.locations.all()
        if len(locations) > 5:
            oldest_location = locations.order_by('date').first()
            oldest_location.delete()
    
    def add_mandatory_location(self, latitude, longitude):
        MandatoryLocation.objects.create(user=self, latitude=latitude, longitude=longitude)
        self.mandatory_count += 1
        self.save()
    
    def fetch_mandatory_locations(self):
        return self.mandatory_locations.all()

    def delete_mandatory_location(self, latitude, longitude):
        error = 0.00001
        loc = self.mandatory_locations.get(
            latitude__range=(latitude - error, latitude + error), 
            longitude__range=(longitude - error, longitude + error)
        )
        loc.delete()
        return 1




class UserLocation(models.Model):
    user = models.ForeignKey(User, related_name='locations', on_delete=models.CASCADE)
    latitude = models.FloatField()
    longitude = models.FloatField()
    date = models.DateTimeField(default=timezone.now)

class MandatoryLocation(models.Model):
    user = models.ForeignKey(User, related_name='mandatory_locations', on_delete=models.CASCADE)
    latitude = models.FloatField()
    longitude = models.FloatField()
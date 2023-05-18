from django.db import models
from django.contrib.auth.models import AbstractUser

class Location(models.Model):
    longitude = models.FloatField()
    latitude = models.FloatField()

    def __str__(self):
        return f'{self.latitude}, {self.longitude}'

class LoginRecord(models.Model):
    user = models.ForeignKey('CustomUser', related_name='login_records', on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True)
    location = models.ForeignKey(Location, related_name='login_locations', on_delete=models.CASCADE)

class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=100)
    mandatory_locations = models.ManyToManyField(Location, related_name='mandatory_locations', blank=True)

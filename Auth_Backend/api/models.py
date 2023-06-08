from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

# Create your models here.

class User(AbstractBaseUser):
    email = models.EmailField(unique=True)
    password = models.TextField()
    USERNAME_FIELD = 'email'
    
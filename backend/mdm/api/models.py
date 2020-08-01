from django.db import models
from django.contrib.auth.models import AbstractUser
from .managers import CustomUserManager


class CustomUser(AbstractUser):
    email = models.EmailField(blank=False, unique=True)
    is_authority = models.BooleanField(default=False)

    objects = CustomUserManager()

    def __str__(self):
        return self.username


class District(models.Model):
    name = models.CharField(max_length=200, blank=False, unique=True)


class Authority(models.Model):
    user = models.OneToOneField(
        CustomUser, on_delete=models.CASCADE, primary_key=True)
    district = models.OneToOneField(District, on_delete=models.PROTECT)

    def __str__(self):
        return '{} - {}'.format(self.user.username, self.district.name)


class School(models.Model):
    user = models.OneToOneField(
        CustomUser, on_delete=models.CASCADE, primary_key=True)
    name = models.CharField(max_length=250, blank=False)
    district = models.ForeignKey(District, on_delete=models.PROTECT, null=True)
    authority = models.ForeignKey(
        Authority, on_delete=models.SET_NULL, null=True)

    def __str__(self):
        return '{} - {}'.format(self.user.username, self.name)


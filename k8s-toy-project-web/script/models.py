from django.contrib.auth.models import User
from django.db import models

# Create your models here.
FLAVOR_CHOICES = (
    ('x1.small','X1.SMALL'),
    ('x1.medium','X1.MEDIUM'),
    ('x1.large','X1.LARGE'),
)

IMAGE_CHOICES = (
    ('centos','CENTOS'),
)


class Script(models.Model):
    project_name = models.CharField(max_length=40)
    key_pair_name = models.CharField(max_length=40)
    flavor = models.CharField(max_length=40,choices=FLAVOR_CHOICES, default='x1.small')
    image = models.CharField(max_length=40,choices=IMAGE_CHOICES,default='centos')
    worker = models.IntegerField(default=0)
    writer = models.ForeignKey(User,on_delete=models.CASCADE)
    create_date = models.DateTimeField(auto_now_add=True)

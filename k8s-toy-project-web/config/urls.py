"""config URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

import script.views
import user.views

urlpatterns = [
    path('admin/', admin.site.urls),

    path('',script.views.main),
    path('script/create',script.views.createScript),
    path('script/readGet/<int:sid>',script.views.readScriptGet),
    path('script/listGet',script.views.listGet),
    path('script/delete/<int:sid>',script.views.delete),

    #path('accounts/',include('allauth.urls'))
    path('user/signup', user.views.singup),
    path('user/login', user.views.login),
    path('user/logout', user.views.logout),
]

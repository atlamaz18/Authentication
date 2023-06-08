from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.hashers import make_password # Used to hash passwords
from django.contrib.auth import get_user_model

from django.http import JsonResponse
import json

@api_view(['POST'])
def create_user(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data['email']
        password = data['password']
        User = get_user_model()
        user = User.objects.create(email=email, password=password)
        return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'not a post request'})

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.hashers import make_password, check_password
from django.contrib.auth import get_user_model
from django.contrib.auth import authenticate, login

from django.http import JsonResponse
import json

@api_view(['POST'])
def create_user(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data['email']
        password = data['password']
        User = get_user_model()
        user = User.objects.create(email=email, password=make_password(password))
        return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'not a post request'})

@api_view(['POST'])
def login_view(request):
    if request.method == "POST":
        data = json.loads(request.body)
        email = data.get('email')
        password = data.get('password')
        User = get_user_model()
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'User does not exist'}, status=400)
        if check_password(password, user.password):
            login(request, user)
            return JsonResponse({'status': 'ok', 'message': 'Logged in successfully'}, status=200)
        else:
            return JsonResponse({'status': 'error', 'message': 'Invalid credentials3'}, status=400)
    else:
        return JsonResponse({'status': 'error', 'message': 'Invalid request method'}, status=400)

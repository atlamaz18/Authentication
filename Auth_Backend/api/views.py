from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.hashers import make_password, check_password
from django.contrib.auth import get_user_model
from django.contrib.auth import authenticate, login
from django.core.exceptions import ObjectDoesNotExist
from django.http import JsonResponse
import json
from datetime import datetime
from .models import User, UserLocation
from .helpers import coordinateToString

@api_view(['POST'])
def create_user(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data['email']
        password = data['password']
        User = get_user_model()
        user = User.objects.create(email=email, password=make_password(password))
        return JsonResponse({'status': 'success'}, status=200)
    else:
        return JsonResponse({'status': 'not a post request'}, status=400)

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

@api_view(['POST'])
def location_check_view(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode('utf-8'))
            user = User.objects.get(email=data['email'])
            latitude = float(data['latitude'])
            longitude = float(data['longitude'])
            date = datetime.strptime(data['date'], '%Y-%m-%dT%H:%M:%S.%f')  # Adjust format if necessary
            user.add_location(latitude, longitude)
            location = user.locations.latest('date')
            location.date = date
            location.save()
            location_info = coordinateToString([latitude, longitude])
            return JsonResponse(location_info, status=200)
        except KeyError:
            return JsonResponse({'error': 'Bad request Key'}, status=400)
        except ValueError:
            return JsonResponse({'error': 'Bad request Value'}, status=400)
        except ObjectDoesNotExist:
            return JsonResponse({'error': 'User not found'}, status=404)
    else:
        return JsonResponse({'error': 'Invalid Method'}, status=405)
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
from .helpers import coordinateToString, MandatoryLocationSerializer, is_possible_travel, check_within_distance

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
            #date = datetime.strptime(data['date'], '%Y-%m-%d – %H:%M:%S')
            date = data['date']
            print(data)
            pre_date = 0
            pre_loc = 0
            pre_loc_lat = 0
            pre_loc_long = 0
            if user.locations.exists():
                locations = user.locations.all()
                pre_loc = user.locations.order_by('-date').first()
                pre_date = data['date']
                pre_loc_lat = pre_loc.latitude
                pre_loc_long = pre_loc.longitude
            else:
                pre_date = data['date']
                pre_loc_lat = latitude
                pre_loc_long = longitude

            possible = False
            
            if user.mandatory_count == 0:
                possible = is_possible_travel([pre_loc_lat, pre_loc_long], [latitude, longitude], date, pre_date)
            else:
                mand_locs = user.fetch_mandatory_locations()
                possible = check_within_distance([latitude, longitude], mand_locs)

            pre_loc_info = coordinateToString([pre_loc_lat, pre_loc_long])
            cur_loc_info = coordinateToString([latitude, longitude])

            json_resp = {}
            json_resp['previousDate'] = pre_date
            json_resp['pre_loc'] = pre_loc_info
            json_resp['cur_loc'] = cur_loc_info
            json_resp['possible'] = possible       
            print(json_resp)
            user.add_location(latitude, longitude, datetime.strptime(data['date'], '%Y-%m-%d – %H:%M:%S')) # Add new received location
            return JsonResponse(json_resp, status=200)
        except KeyError:
            return JsonResponse({'error': 'Bad request Key'}, status=400)
        except ValueError:
            return JsonResponse({'error': 'Bad request Value'}, status=400)
        except ObjectDoesNotExist:
            return JsonResponse({'error': 'User not found'}, status=404)
    else:
        return JsonResponse({'error': 'Invalid Method'}, status=405)

@api_view(['POST'])
def change_settings_view(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data.get('email')
        password = data.get('password')
        new_email = data.get('newemail')
        new_password = data.get('newpassword')
        User = get_user_model()
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return JsonResponse({'status': 'error', 'error': 'User not found'}, status=400)
        if not check_password(password, user.password):
            return JsonResponse({'status': 'error', 'error': 'Incorrect password'}, status=400)
        if new_email is not None:
            user.email = new_email
        if new_password is not None:
            user.password = make_password(new_password)
        user.save()
        return JsonResponse({'status': 'success'}, status=200)
    else:
        return JsonResponse({'status': 'error', 'error': 'Invalid request'}, status=400)

@api_view(['POST'])
def get_mandatory_locations_view(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        email = data.get('email')
        User = get_user_model()
        user = User.objects.get(email=email)
        mandatory_locs = user.fetch_mandatory_locations()
        serializer = MandatoryLocationSerializer(mandatory_locs, many=True)
        return Response(serializer.data)

@api_view(['POST'])
def add_mandatory_location_view(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            User = get_user_model()
            user = User.objects.get(email=email)
            if user.mandatory_count == 10:
                return JsonResponse({'error': 'Reached limit for mandatory location'}, status=400)
            user.add_mandatory_location(data['latitude'], data['longitude'])
            return JsonResponse({'status': 'success'}, status=200)
        except KeyError:
            return JsonResponse({'error': 'Bad request Key'}, status=400)
        except ValueError:
            return JsonResponse({'error': 'Bad request Value'}, status=400)
    
@api_view(['POST'])
def delete_mandatory_location(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            print(data)
            email = data.get('email')
            User = get_user_model()
            user = User.objects.get(email=email)
            user.delete_mandatory_location(data['latitude'], data['longitude'])
            return JsonResponse({'status': 'success'}, status=200) 
        except KeyError:
            return JsonResponse({'error': 'Bad request Key'}, status=400)
        except ValueError:
            return JsonResponse({'error': 'Bad request Value'}, status=400)


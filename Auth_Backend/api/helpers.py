from geopy.geocoders import Nominatim
from geopy.distance import great_circle
from datetime import datetime
from rest_framework import serializers
from .models import MandatoryLocation

class MandatoryLocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = MandatoryLocation
        fields = ['latitude', 'longitude']


# Takes a coordinate in form of [longtitute, latitude] and returns geographic location as dictionary.
def coordinateToString(coord):
    loc = str(coord[0]) + ", " + str(coord[1])
    geolocator = Nominatim(user_agent="auth_app")
    location = geolocator.reverse(loc)
    raw_data = location.raw['address']
    data = ""
    if 'town' in raw_data:
        data = data + raw_data['town'] + ","
    data = data + raw_data['province'] + "," + raw_data['country']
    return data

# Returns distance between two coordinates in kilometers
def calcDistance(cord1, cord2):
    return great_circle(cord1, cord2).kilometers

# Adjust
def is_possible_travel(prev_location, curr_location, prev_date_str, curr_date_str, speed=500):
    # Calculate the time difference in hours
    prev_date = parse_date(prev_date_str)
    curr_date = parse_date(curr_date_str)
    time_diff = (curr_date - prev_date).total_seconds() / 3600
    # Calculate the maximum distance that could be traveled
    max_distance = speed * time_diff

    # Calculate the actual distance
    actual_distance = calcDistance(prev_location, curr_location)
    if actual_distance < 3:
        return True
    # Return whether it is possible to travel the actual distance in the time difference
    return actual_distance <= max_distance

def check_within_distance(current_location, location_list):
    threshold_km = 3
    for location in location_list:
        if calcDistance(current_location, [location.latitude, location.longitude]) <= threshold_km:
            return True
    return False

def parse_date(date_str):
    formats = ["%Y-%m-%d – %H:%M:%S", "%Y-%m-%d - %H:%M:%S"]

    for fmt in formats:
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    raise ValueError(f"No valid date format found for {date_str}")
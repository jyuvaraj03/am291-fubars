from djoser.serializers import UserCreateSerializer, UserSerializer
from rest_framework import serializers
from .models import CustomUser, Authority, School, District
from django.db import transaction


class CustomUserCreateSerializer(UserCreateSerializer):

    class Meta(UserCreateSerializer.Meta):
        fields = [
            'id',
            'username',
            'email',
            'password',
        ]


class CustomUserSerializer(UserSerializer):

    class Meta(UserSerializer.Meta):
        fields = [
            'id',
            'username',
            'email',
            'is_authority',
        ]


class AuthoritySerializer(serializers.ModelSerializer):

    class Meta:
        model = Authority
        fields = [
            'user_id',
            'district',
        ]

    @transaction.atomic
    def create(self, validated_data):
        authority = Authority.objects.create(**validated_data)
        schools = School.objects.filter(district=authority.district)
        for school in schools:
            school.authority = authority
        School.objects.bulk_update(schools, ['authority'])
        return authority


class SchoolSerializer(serializers.ModelSerializer):

    class Meta:
        model = School
        fields = [
            'user_id',
            'name',
            'district',
        ]

    def create(self, validated_data):
        try:
            authority = Authority.objects.get(
                district=validated_data['district'])
            return School.objects.create(authority=authority, **validated_data)
        except Authority.DoesNotExist:
            return School.objects.create(**validated_data)
        except Exception as e:
            pass


class DistrictSerializer(serializers.ModelSerializer):

    class Meta:
        model = District
        fields = '__all__'

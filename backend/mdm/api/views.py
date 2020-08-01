from rest_framework.permissions import BasePermission, IsAuthenticated, IsAuthenticatedOrReadOnly, SAFE_METHODS
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import generics
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from django.http import Http404
from .permissions import IsOwnerOrReadOnly, IsSchoolOwner, IsOwner
from .serializers import AuthoritySerializer, SchoolSerializer, DistrictSerializer
from .models import Report, School, Authority, District


class MeRetrieveUpdate(generics.RetrieveUpdateAPIView):
    """
    RetrieveUpdateAPIView for read and update of objects with 
    logged in user.
    """

    def get_object(self):
        """
        Returns the object of the current logged in user.
        """
        queryset = self.filter_queryset(self.get_queryset())
        try:
            obj = get_object_or_404(queryset, user=self.request.user)
            self.check_object_permissions(self.request, obj)
            return obj
        except (TypeError, ValueError, ValidationError):
            raise Http404


class AuthorityEnroll(generics.CreateAPIView):
    queryset = Authority.objects.all()
    serializer_class = AuthoritySerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        user = self.request.user
        user.is_authority = True
        user.save()
        return serializer.save(user=user)


class AuthorityMeRetrieveUpdate(MeRetrieveUpdate):
    """
    Retrieve or update the current logged in authority details.
    """
    queryset = Authority.objects.all()
    serializer_class = AuthoritySerializer
    permission_classes = [IsAuthenticated, IsOwner]


class SchoolEnroll(generics.CreateAPIView):
    queryset = School.objects.all()
    serializer_class = SchoolSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        return serializer.save(user=self.request.user)


class SchoolMeRetrieveUpdate(MeRetrieveUpdate):
    """
    Retrieve or update the current logged in school details.
    """
    queryset = School.objects.all()
    serializer_class = SchoolSerializer
    permission_classes = [IsAuthenticated, IsOwner]


class DistrictList(generics.ListAPIView):
    """
    List all the districts.
    """
    queryset = District.objects.all()
    serializer_class = DistrictSerializer

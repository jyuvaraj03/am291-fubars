from rest_framework.permissions import BasePermission, IsAuthenticated, IsAuthenticatedOrReadOnly, SAFE_METHODS
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import generics
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from django.http import Http404
from .permissions import IsOwnerOrReadOnly, IsSchoolOwner, IsOwner
from .serializers import SchoolReportSerializer, SchoolReportCreateSerializer, AuthoritySerializer, SchoolSerializer, DistrictSerializer, AuthorityReportSerializer, EstimateReportSerializer
from .models import Report, School, Authority, District, AuthorityReport


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


class AuthorityReportList(generics.ListAPIView):
    queryset = AuthorityReport.objects.all()
    serializer_class = AuthorityReportSerializer
    permission_classes = [IsAuthenticated]


class AuthorityReportDiscrepancyList(generics.ListAPIView):
    queryset = AuthorityReport.objects.all()
    serializer_class = AuthorityReportSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request):
        queryset = self.get_queryset()

        serializer = AuthorityReportSerializer([x for x in queryset if x.is_discrepant], many=True)
        return Response(serializer.data)

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


class SchoolReportCreate(generics.CreateAPIView):
    """
    Creates new reports by school.
    Request has to be initiated by the owner school.
    """
    queryset = Report.objects.all()
    serializer_class = SchoolReportCreateSerializer
    permission_classes = [IsAuthenticated, IsSchoolOwner]

    def perform_create(self, serializer):
        user = self.request.user
        school = School.objects.get(user=user)
        return serializer.save(school=school)


class SchoolReportList(generics.ListAPIView):
    """
    Lists all the reports created by a school.
    Request has to be initiated by the owner school.
    """
    queryset = Report.objects.all()
    serializer_class = SchoolReportSerializer
    permission_classes = [IsAuthenticated, IsSchoolOwner]

    def list(self, request):
        queryset = self.get_queryset()
        serializer = SchoolReportSerializer(queryset.filter(
            school__user=request.user, added_by_school=True), many=True)
        return Response(serializer.data)


class SchoolReportRetrieve(generics.RetrieveAPIView):
    """
    Retrieve reports created by currently
    logged in school.
    """
    queryset = Report.objects.filter(added_by_school=True)
    serializer_class = SchoolReportSerializer
    permission_classes = [IsAuthenticated, IsSchoolOwner]


class DistrictList(generics.ListAPIView):
    """
    List all the districts.
    """
    queryset = District.objects.all()
    serializer_class = DistrictSerializer

class EstimateReportListCreate(generics.ListCreateAPIView):
    """
    Lists all the estimated reports.
    """
    queryset = Report.objects.all()
    serializer_class = EstimateReportSerializer

    def list(self, request):
        queryset = self.get_queryset()
        serializer = EstimateReportSerializer(queryset.filter(added_by_school=False), many=True)
        return Response(serializer.data)

    def perform_create(self, serializer):
        return serializer.save()

class EstimateReportRetrieveUpdate(generics.RetrieveUpdateAPIView):

    queryset = Report.objects.filter(added_by_school=False)
    serializer_class = EstimateReportSerializer

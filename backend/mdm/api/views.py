from rest_framework.permissions import BasePermission, IsAuthenticated, IsAuthenticatedOrReadOnly, SAFE_METHODS
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import generics
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from django.http import Http404
from .permissions import IsOwnerOrReadOnly, IsSchoolOwner, IsOwner
from .serializers import SchoolReportSerializer, AuthoritySerializer, SchoolSerializer, DistrictSerializer, AuthorityReportSerializer, EstimateReportSerializer
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


class AuthorityReportList(APIView):
    """
    Lists all the reports created by schools under the
    currently logged in authority.
    """

    permission_classes = [IsAuthenticated]

    def get(self, request, format=None):
        """
        Return the list of reports under authority.
        """
        authority = Authority.objects.get(user=request.user)
        schools = authority.school_set.all()
        reports = Report.objects.filter(school__in=schools)

        response_data = []

        for school in schools:

            actual_reports = reports.filter(
                actual_report__isnull=True, school=school)
            for actual_report in actual_reports:
                try:
                    estimate_report = actual_report.estimate_report

                    serializer = AuthorityReportSerializer(
                        actual_report=actual_report, estimate_report=estimate_report)
                    response_data.append(serializer.data)

                except Report.DoesNotExist:
                    serializer = AuthorityReportSerializer(
                        actual_report=actual_report)
                    response_data.append(serializer.data)

                except ValidationError as ve:
                    print(ve)

                except Exception as e:
                    print(e)

        return Response(response_data)


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


class SchoolReportListCreate(generics.ListCreateAPIView):
    """
    Creates new reports by school.
    Lists all the reports created by a school.
    Request has to be initiated by the owner school.
    """
    queryset = Report.objects.all()
    serializer_class = SchoolReportSerializer
    permission_classes = [IsAuthenticated, IsSchoolOwner]

    def list(self, request):
        queryset = self.get_queryset()
        serializer = SchoolReportSerializer(queryset.filter(
            school__user=request.user, actual_report__isnull=True), many=True)
        return Response(serializer.data)

    def perform_create(self, serializer):
        user = self.request.user
        school = School.objects.get(user=user)
        return serializer.save(school=school)


class SchoolReportRetrieveUpdate(generics.RetrieveUpdateAPIView):
    """
    Retrieve or update reports created by currently
    logged in school.
    """
    queryset = Report.objects.filter(actual_report__isnull=True)
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
        serializer = EstimateReportSerializer(queryset.filter(actual_report__isnull=False), many=True)
        return Response(serializer.data)

    def perform_create(self, serializer):
        return serializer.save()

class EstimateReportRetrieveUpdate(generics.RetrieveUpdateAPIView):

    queryset = Report.objects.filter(actual_report__isnull=False)
    serializer_class = EstimateReportSerializer

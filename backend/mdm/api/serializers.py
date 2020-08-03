from djoser.serializers import UserCreateSerializer, UserSerializer
from rest_framework import serializers
from .models import CustomUser, Authority, School, Report, District, ReportItem, Schedule, AuthorityReport
from collections import OrderedDict
from django.core.exceptions import ValidationError
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


class ReportItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = ReportItem
        fields = [
            'item',
        ]


class SchoolReportSerializer(serializers.ModelSerializer):
    items = ReportItemSerializer(many=True)

    class Meta:
        model = Report
        fields = [
            'id',
            'student_count',
            'for_date',
            'items'
        ]


class SchoolReportCreateSerializer(serializers.ModelSerializer):

    class Meta:
        model = Report
        fields = [
            'id',
            'student_count',
            'for_date',
        ]

    @transaction.atomic
    def create(self, validated_data):
        # Should pass the items
        school = validated_data.get('school')
        for_date = validated_data.get('for_date')
        for_day = for_date.weekday()
        items_data = Schedule.objects.filter(district=school.district, day=for_day)
        report = Report.objects.create(**validated_data, added_by_school=True)
        try:
            estimate_report = Report.objects.get(
                school=school, for_date=for_date)
            estimate_report.actual_report = report
            estimate_report.save()
        except:
            pass
        finally:
            for item_data in items_data:
                item = item_data.item
                ReportItem.objects.create(report=report, item=item)
            return report


class EstimateReportSerializer(serializers.ModelSerializer):
    items = ReportItemSerializer(many=True, required=False, allow_null=False)

    class Meta:
        model = Report
        fields = [
            'id',
            'student_count',
            'for_date',
            'items',
            'school',
        ]

    @transaction.atomic
    def create(self, validated_data):
        items_data = validated_data.pop('items')
        school = validated_data.get('school')
        for_date = validated_data.get('for_date')
        try:
            actual_report = Report.objects.get(
                school=school, for_date=for_date)
            report = Report.objects.create(
                actual_report=actual_report, **validated_data)
        except Report.DoesNotExist:
            report = Report.objects.create(**validated_data)
        finally:
            for item_data in items_data:
                ReportItem.objects.create(report=report, **item_data)
            return report

    @transaction.atomic
    def update(self, instance, validated_data):
        items_data = validated_data.pop('items')
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        if items_data:
            instance.items.all().delete()
            for item_data in items_data:
                ReportItem.objects.create(report=instance, **item_data)
        instance.save()
        return instance


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


class AuthorityReportSerializer(serializers.ModelSerializer):
    is_discrepant = serializers.ReadOnlyField()
    school = SchoolSerializer()
    estimate = EstimateReportSerializer()
    actual = SchoolReportSerializer()

    class Meta:
        model = AuthorityReport
        fields = [
            'id',
            'for_date',
            'school',
            'estimate',
            'actual',
            'is_discrepant'
        ]


class DistrictSerializer(serializers.ModelSerializer):

    class Meta:
        model = District
        fields = '__all__'

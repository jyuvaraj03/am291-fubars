from djoser.serializers import UserCreateSerializer, UserSerializer
from rest_framework import serializers
from .models import CustomUser, Authority, School, Report, District, ReportItem
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
            'items',
        ]

    @transaction.atomic
    def create(self, validated_data):
        items_data = validated_data.pop('items')
        report = Report.objects.create(**validated_data)
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


class EstimateReportSerializer(serializers.ModelSerializer):
    items = ReportItemSerializer(many=True)

    class Meta:
        model = Report
        fields = [
            'id',
            'student_count',
            'for_date',
            'items',
        ]

    @transaction.atomic
    def create(self, validated_data):
        items_data = validated_data.pop('items')
        school = validated_data.get('school')
        for_date = validated_data.get('for_date')
        actual_report = Report.objects.get(school=school, for_date=for_date)
        report = Report.objects.create(
            actual_report=actual_report, **validated_data)
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


class AuthorityReportSerializer(serializers.Serializer):
    """
    Custom Serializer for authority reports.
    Required inputs as kwargs:
    * actual_report: Actual report object
    * estimate_report: Estimate report object of the actual report
    """

    def __init__(self, *args, **kwargs):
        actual_report = kwargs.pop('actual_report', None)
        estimate_report = kwargs.pop('estimate_report', None)
        super(AuthorityReportSerializer, self).__init__(*args, **kwargs)

        self._data = OrderedDict()

        if not (actual_report or estimate_report):
            raise ValidationError(
                _('Neither actual report nor estimate report is given.'))

        if actual_report and estimate_report:
            if actual_report.for_date != estimate_report.for_date:
                raise ValidationError(
                    _('The for date in the reports do not match.'))

            if actual_report.school != estimate_report.school:
                raise ValidationError(
                    _('The schools in the report do not match.'))

        if actual_report:
            self._data['actual_student_count'] = actual_report.student_count
            self._data['actual_items'] = ReportItemSerializer(
                actual_report.items, many=True).data
            self._data['school'] = SchoolSerializer(actual_report.school).data
            self._data['for_date'] = actual_report.for_date
        else:
            self._data['actual_student_count'] = 0
            self._data['actual_items'] = ReportItemSerializer(
                [], many=True).data

        if estimate_report:
            self._data['estimate_student_count'] = estimate_report.student_count
            self._data['estimate_items'] = ReportItemSerializer(
                estimate_report.items, many=True).data
            self._data['school'] = SchoolSerializer(estimate_report.school).data
            self._data['for_date'] = estimate_report.for_date
        else:
            self._data['estimate_student_count'] = 0
            self._data['estimate_items'] = ReportItemSerializer(
                [], many=True).data


class DistrictSerializer(serializers.ModelSerializer):

    class Meta:
        model = District
        fields = '__all__'

from django.urls import include, path
from . import views

urlpatterns = [
  path('authorities/', views.AuthorityEnroll.as_view(), name='authority_enroll'),
  path('authorities/me/', views.AuthorityMeRetrieveUpdate.as_view(), name='authority_me_retrieve_update'),
  path('authorities/me/reports/', views.AuthorityReportList.as_view(), name='authority_report_list'),
  path('schools/', views.SchoolEnroll.as_view(), name='school_enroll'),
  path('schools/me/', views.SchoolMeRetrieveUpdate.as_view(), name='school_me_retrieve_update'),
  path('schools/me/reports/', views.SchoolReportCreate.as_view(), name='school_report_create'),
  path('schools/me/reports/list', views.SchoolReportList.as_view(), name='school_report_list'),
  path('schools/me/reports/<int:pk>', views.SchoolReportRetrieve.as_view(), name='school_report_retrieve'),
  path('schools/me/reports/update/<int:pk>', views.SchoolReportUpdate.as_view(), name='school_report_update'),
  path('districts/', views.DistrictList.as_view(), name='district_list'),
  path('estimate/reports/',views.EstimateReportListCreate.as_view(), name='estimate_report_list_create'),
  path('estimate/reports/<int:pk>', views.EstimateReportRetrieveUpdate.as_view(), name='estimate_report_retrieve_update'),
]
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.core.mail import send_mail
from api.models import Report, AuthorityReport

@receiver(post_save, sender=Report)
def create_authority_report(sender, instance, created, **kwargs):
    try:
        # create authority report only when both actual and estimate report exists
        other_report = Report.objects.get(school=instance.school, for_date=instance.for_date, added_by_school=(not instance.added_by_school))

        if instance.added_by_school:
            AuthorityReport.objects.create(school=instance.school, actual=instance, estimate=other_report, for_date=instance.for_date)
        else:
            AuthorityReport.objects.create(school=instance.school, estimate=instance, actual=other_report, for_date=instance.for_date)

    except Report.DoesNotExist:
        pass

@receiver(post_save, sender=AuthorityReport)
def send_discrepancy_email(sender, instance, created, **kwargs):
    if instance.is_discrepant:
        send_mail(
            'Report Discrepancy: School {} - {}'.format(instance.school.name, instance.for_date),
            """
            Dear Sir/Madam,

            There seems to be a discrepancy in the {}'s report for the school {}. 

            Report given by school:

            Student count: {},
            Food items: {}

            Report predicted by the system:

            Student count: {},
            Food items: {}
            """.format(instance.for_date, instance.school.name, 
                       instance.actual.student_count, instance.actual.items.all(),
                       instance.estimate.student_count, instance.estimate.items.all()),
            'jyuvaraj000@gmail.com',
            [instance.school.authority.user.email],
            # [instance.school.authority.email],
            fail_silently=False,
        )
                
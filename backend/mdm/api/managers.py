from django.contrib.auth.base_user import BaseUserManager
from django.utils.translation import ugettext as _
from email_validator import validate_email, EmailNotValidError

class CustomUserManager(BaseUserManager):
    """
    Custom user model manager where additional attributes such as
    phone number, etc are saved.
    """
    def create_user(self, username, password, email, **extra_fields):
        """
        Create and save a CustomUser with the given username
        and password.
        """
        if not username:
            raise ValueError(_('The username must be set'))
        if not email:
            raise ValueError(_('The email must be set'))
        if not password:
            raise ValueError(_('The password must be set'))
        email = self.normalize_email(email)
        try:
            valid = validate_email(email)
            email = valid.email
        except EmailNotValidError:
            raise EmailNotValidError(_('The email address is not valid'))
        user = self.model(username=username, email=email, **extra_fields)
        user.set_password(password)
        user.save()
        return user
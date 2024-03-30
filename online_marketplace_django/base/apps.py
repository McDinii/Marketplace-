from django.apps import AppConfig


class BaseConfig(AppConfig):
    name = 'base'

    def ready(self):
        from django.contrib.auth.models import User  # Перенесен импорт внутрь функции ready()
        from .signals import updateUser
        from django.db.models.signals import pre_save

        pre_save.connect(updateUser, sender=User)

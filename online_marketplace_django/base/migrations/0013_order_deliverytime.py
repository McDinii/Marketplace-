# Generated by Django 3.1.4 on 2023-05-17 17:50

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0012_remove_order_deliverytime'),
    ]

    operations = [
        migrations.AddField(
            model_name='order',
            name='deliveryTime',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]

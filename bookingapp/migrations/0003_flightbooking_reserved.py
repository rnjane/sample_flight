# Generated by Django 2.1.4 on 2018-12-23 21:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bookingapp', '0002_auto_20181223_2016'),
    ]

    operations = [
        migrations.AddField(
            model_name='flightbooking',
            name='reserved',
            field=models.BooleanField(default=False),
        ),
    ]

# Generated by Django 2.1.4 on 2018-12-23 20:16

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('bookingapp', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='FlightBooking',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
        ),
        migrations.RemoveField(
            model_name='flight',
            name='id',
        ),
        migrations.AlterField(
            model_name='flight',
            name='name',
            field=models.CharField(max_length=30, primary_key=True, serialize=False),
        ),
        migrations.AddField(
            model_name='flightbooking',
            name='flight',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_booking', to='bookingapp.Flight'),
        ),
        migrations.AddField(
            model_name='flightbooking',
            name='owner',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='bucketlists', to=settings.AUTH_USER_MODEL),
        ),
    ]

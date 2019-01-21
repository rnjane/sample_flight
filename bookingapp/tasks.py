from celery.task.schedules import crontab
from celery.decorators import periodic_task
from celery.utils.log import get_task_logger
from django.core.mail import send_mail
from django.conf import settings
from . import models
from datetime import datetime, timedelta

logger = get_task_logger(__name__)

def flight_reminder():
    flight_bookings = models.FlightBooking.objects.all()
    for flight_booking in flight_bookings:
        flight_time = flight_booking.flight.date_time_of_flight
        if datetime.now(flight_time.tzinfo) + timedelta(hours=24) >= flight_time >= datetime.now(flight_time.tzinfo) + timedelta(hours=23, minute=30):
            send_mail(
            'Reminder: Your upcoming flight',
            flight_booking.flight.name + "Will be on" + flight_booking.flight.date_time_of_flight.strftime("%Y-%m-%d %H:%M:%S"),
            settings.EMAIL_HOST_USER,
            [flight_booking.owner.email, 'robert.ndungu@hotmail.com'],
            fail_silently=True,
            )

@periodic_task(
    run_every=(crontab(minute='*/60')),
    name="send_reminder_email",
    ignore_result=True
)
def send_reminder_email():
    flight_reminder()
    logger.info("Reminder email sent")
# Generated by Django 4.2.1 on 2023-06-12 14:45

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_userlocation'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='mandatory_count',
            field=models.IntegerField(default=0),
        ),
        migrations.CreateModel(
            name='MandatoryLocation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('latitude', models.FloatField()),
                ('longitude', models.FloatField()),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='mandatory_locations', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
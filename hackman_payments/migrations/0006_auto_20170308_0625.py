# -*- coding: utf-8 -*-
# Generated by Django 1.10.5 on 2017-03-08 06:25
from __future__ import unicode_literals

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('hackman_payments', '0005_auto_20170308_0621'),
    ]

    operations = [
        migrations.AlterField(
            model_name='paymenttag',
            name='user',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
    ]
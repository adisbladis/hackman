# Generated by Django 4.0.4 on 2022-05-31 18:27

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("hackman_rfid", "0003_auto_20170218_0528"),
    ]

    operations = [
        migrations.AlterField(
            model_name="rfidcard",
            name="id",
            field=models.AutoField(primary_key=True, serialize=False),
        ),
    ]

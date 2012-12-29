# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Name'
        db.create_table('name_name', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('gender', self.gf('django.db.models.fields.CharField')(max_length=1)),
            ('description', self.gf('django.db.models.fields.TextField')()),
            ('rate', self.gf('django.db.models.fields.IntegerField')()),
            ('link', self.gf('django.db.models.fields.URLField')(max_length=200)),
        ))
        db.send_create_signal('name', ['Name'])


    def backwards(self, orm):
        # Deleting model 'Name'
        db.delete_table('name_name')


    models = {
        'name.name': {
            'Meta': {'object_name': 'Name'},
            'description': ('django.db.models.fields.TextField', [], {}),
            'gender': ('django.db.models.fields.CharField', [], {'max_length': '1'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'link': ('django.db.models.fields.URLField', [], {'max_length': '200'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'rate': ('django.db.models.fields.IntegerField', [], {})
        }
    }

    complete_apps = ['name']
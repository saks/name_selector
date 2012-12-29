# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding unique constraint on 'Name', fields ['gender', 'name']
        db.create_unique('name_name', ['gender', 'name'])


    def backwards(self, orm):
        # Removing unique constraint on 'Name', fields ['gender', 'name']
        db.delete_unique('name_name', ['gender', 'name'])


    models = {
        'name.name': {
            'Meta': {'unique_together': "(('name', 'gender'),)", 'object_name': 'Name'},
            'description': ('django.db.models.fields.TextField', [], {}),
            'gender': ('django.db.models.fields.CharField', [], {'max_length': '1'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'link': ('django.db.models.fields.URLField', [], {'max_length': '200'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'rate': ('django.db.models.fields.IntegerField', [], {})
        }
    }

    complete_apps = ['name']
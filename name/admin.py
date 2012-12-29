#-*- coding: utf-8 -*-

from django.contrib import admin
from name.models import Name

def dislike(modeladmin, request, queryset):
    queryset.update(rate=-1)
dislike.short_description = "Mark selected as not liked"

class NameAdmin(admin.ModelAdmin):
    list_display = ['name_link', 'rate', 'description', ]
    search_fields = ('name',)
    list_filter = ['gender', 'rate']
    list_editable = ('rate',)
    ordering = ('-rate', 'name')
    actions = [dislike]
    list_per_page = 15

    def description(self):
        return self.description
    description.allow_tags = True
    description.admin_order_field = 'description'

    def name_link(self, obj):
        return u'<a href="%s">%s</a>' % (obj.link, obj.name)
    name_link.allow_tags = True
    name_link.admin_order_field = 'id'

    def get_actions(self, request):
        actions = super(NameAdmin, self).get_actions(request)
        if 'delete_selected' in actions:
            del actions['delete_selected']
        return actions

admin.site.register(Name, NameAdmin)

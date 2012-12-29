from django.db import models
from django.utils.translation import ugettext_lazy as _

GENDERS = (
    ('1', _(u'Female')),
    ('2', _(u'Male')),
)
class Name(models.Model):
    name = models.CharField(_(u'Name'), max_length=255)
    gender = models.CharField(_('Gender'), choices=GENDERS, max_length=1)
    description = models.TextField(_(u'Meaning'))
    rate = models.IntegerField(_('Rating'), default=0)
    link = models.URLField(_(u'External Link'))

    class Meta:
        verbose_name = _(u'Name')
        verbose_name_plural = _(u'Names')
        unique_together = ('name', 'gender')

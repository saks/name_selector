from django.shortcuts import render_to_response, redirect
from django.utils import simplejson
from django.http import HttpResponse

from name.models import Name

def main(request):
    return render_to_response('index.html')

def names(request, gender):
    if request.is_ajax():
        GENDER_DICT = {'female': 1, 'male': 2}
        names = dict(Name.objects.\
            filter(gender=GENDER_DICT[gender]).\
            order_by('name').\
            values_list('id', 'name'))
    else:
        return redirect('name.views.main')
    return HttpResponse(simplejson.dumps(names), mimetype='application/json')

def description(request):
    pass



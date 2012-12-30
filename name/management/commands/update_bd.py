# -*- coding=utf-8 -*-

'''
Update BD from http://vseimena.com
'''
import pprint
import urllib
import urllib2
from BeautifulSoup import BeautifulSoup

from optparse import make_option
from django.conf import settings
from django.core.management.base import BaseCommand

from name.models import Name

URL = 'http://vseimena.com'

def _parse_names(soup, gender):
    for name in soup.findAll('div', attrs={'class': 'one_name'}):
        try:
            name_link=dict(name.find('a').attrs)['href']
            name = name.find('a').text
        except AttributeError:
            name_link=''
            name = name.text
        print 'name: ', name
        n, created = Name.objects.get_or_create(name=name, gender=gender)
        n.link = URL + name_link
        n.save()
        # get description
        if not n.description and name_link:
            soup = BeautifulSoup(''.join(urllib.urlopen(n.link).readlines()))
            n.description = soup.find('div', attrs={'class': 'pages_body_text'}).text
            n.save()

def _get_urls(url, urls):
    result = urls
    recheck = False
    soup = BeautifulSoup(''.join(urllib.urlopen(url).readlines()))
    pages = soup.find('div', attrs={'class': 'pagination_top'}).findChildren('a')
    for page in pages:
        url = URL + dict(page.attrs)['href']
        result.append(url)
    for url in result:
        soup = BeautifulSoup(''.join(urllib.urlopen(url).readlines()))
        new_pages = soup.find('div', attrs={'class': 'pagination_top'}).findChildren('a')
        for p in new_pages:
            new_url = URL + dict(p.attrs)['href']
            if new_url not in result:
                result.append(new_url)
                recheck = True
    return result, recheck
        

class Command(BaseCommand):

    def handle(self, *args, **kwargs):
        # process female
        gender = 1
        soup = BeautifulSoup(''.join(urllib.urlopen(URL).readlines()))
        letter_links = soup.find('div', attrs={'class': 'female_letters'}).findChildren('a')
        for link in letter_links:  #13, 0
            print 'Process link: ', link
            link = dict(link.attrs)['href']
            url = URL + link
            urls = []
            urls, recheck = _get_urls(url, urls)
            print urls, recheck
            while recheck:
                urls, recheck = _get_urls(url, urls)
            urls.append(url)
            urls = list(set(urls))
            print urls

            # parse other pages of letter
            for url in urls:
                soup = BeautifulSoup(''.join(urllib.urlopen(url).readlines()))
                _parse_names(soup, gender)

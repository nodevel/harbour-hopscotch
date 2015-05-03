# -*- coding: utf-8 -*-

import re
import urllib.request, urllib.parse, urllib.error
from html.parser import HTMLParser # for parsing the web page

CATEGORIES = [
    "application", "app_wallpaper", "app_widgets", "arcade",
    "books_and_reference", "brain", "business", "cards",
    "casual", "comics", "communication", "education",
    "entertainment", "finance", "game", "game_wallpaper",
    "game_widgets", "health_and_fitness", "libraries_and_demo", "lifestyle",
    "media_and_video", "medical", "music_and_audio", "news_and_magazines",
    "personalization", "photography", "productivity", "racing",
    "shopping", "social", "sports", "sports_games",
    "tools", "transportation", "travel_and_local", "weather"
]

FREE = 'topselling_free'
PAID = 'topselling_paid'

class AppsHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.in_card = False
        self.in_details = False
        self.in_title = False
        self.in_subtitle = False
        self.in_price = False
        self.in_rating = False
        self.in_cover = False
        self.app_ids = []
        self.app_names = []
        self.output = []
        self.app = {}
        self.i = -1

    def handle_starttag(self, tag, attrs): # this handles start tags, like <a>
        if (tag == 'div'):
            for name, value in attrs:
                if name == 'class':
                    if value == 'current-rating':
                        self.in_rating = True
                    elif value == 'details':
                        self.in_details = True
                    elif 'card-content' in value:
                        self.in_card = True
                elif name == 'data-docid' and self.in_card:
                    self.i = self.i + 1
                    self.output.append({})
                    self.output[self.i]['Id'] = value
                    self.in_card = False
                elif name == 'style' and self.in_rating:
                    self.output[self.i]['rating'] = float(re.compile(r'[^\d.]+').sub('', value))
                    self.in_rating = False
        elif (tag == 'a') and self.in_details:
            for name, value in attrs:
                if name == 'class' and value == 'title':
                    self.in_title = True
                elif name == 'class' and value == 'subtitle':
                    self.in_subtitle = True
                if name == 'title':
                    if self.in_title:
                        self.output[self.i]['name'] = encodify(value)
                        self.in_title = False
                    elif self.in_subtitle:
                        self.output[self.i]['author'] = encodify(value)
                        self.in_subtitle = False
        elif (tag == 'span') and self.in_details:
            for name, value in attrs:
                if name == 'class' and value == 'display-price':
                    self.in_price = True
        elif (tag == 'img'):
            for name, value in attrs:
                if name == 'data-cover-large':
                    self.output[self.i]['cover_large'] = value
                elif name == 'data-cover-small':
                    self.output[self.i]['cover'] = value
                #if name == 'class' and value == 'cover-image':
                    #self.in_cover = True
                #elif self.in_cover and name == 'src':
                    #self.output[self.i]['cover'] = value
                    #self.in_cover = False

                
    def handle_data(self, data): # this handles data inside of a tag. for example when you have <a>This is a link</a>, then this will handle the "This is the link" part.
        if self.in_price:
            self.output[self.i]['price'] = data.strip()
            self.in_price = False
        
    def handle_endtag(self, tag): # this function is called when an end tag (like </a> ) is encountered
        pass

class AppHTMLParser(HTMLParser):
    def __init__(self, url):
        HTMLParser.__init__(self)
        self.in_description = False
        self.in_genre = False
        self.in_details = False
        self.in_title = 0
        self.in_subtitle = False
        self.in_price = False
        self.in_rating = False
        self.in_cover = False
        self.in_author = False
        self.in_inapp_msg = False
        self.in_name = False # Generic name element
        self.in_author_id = False
        self.rating_set = False # If rating found
        self.in_version = False
        self.in_downloads = False
        self.in_size = False
        self.in_datepublished = False
        self.in_os = False
        self.in_contentrating = False
        self.in_screenshot = False
        self.in_recommendations = False
        self.take_recommendation = False
        self.app_ids = []
        self.app_names = []
        self.output = {}
        self.output['screenshots'] = []
        self.output['recommendations'] = []
        self.cover_tmp = "" # workaround for multiple covers
        self.feed(str(get(url)))

    def handle_starttag(self, tag, attrs): # this handles start tags, like <a>
        if (tag == 'div'):
            #print("in div")
            if (self.in_title == 1):
                self.in_title = 2
            for name, value in attrs:
                #print(name, value)
                if name == 'class':
                    if value == 'id-app-orig-desc':
                        self.in_description = True
                    elif value == 'author':
                        self.in_author = True
                    elif value == 'document-title':
                        self.in_title = 1
                    elif value == 'details-info':
                        self.in_details = True
                    elif value == 'inapp-msg':
                        self.in_inapp_msg = True
                        self.in_details = False
                    elif value == 'document-subtitle':
                        if self.in_author:
                            self.in_subtitle = True
                    elif value == 'details-section recommendation':
                        self.in_recommendations = True
                    elif value == 'secondary-content':
                        self.in_recommendations = False
                elif name == 'itemprop':
                    if value == 'author':
                        self.in_author = True
                    elif value == 'aggregateRating':
                        self.in_rating = True
                    elif value == 'datePublished':
                        self.in_datepublished = True
                    elif value == 'fileSize':
                        self.in_size = True
                    elif value == 'numDownloads':
                        self.in_downloads = True
                    elif value == 'softwareVersion':
                        self.in_version = True
                    elif value == 'operatingSystems':
                        self.in_os = True
                    elif value == 'contentRating':
                        self.in_contentrating = True
                elif self.in_recommendations and name == 'data-docid':
                    self.take_recommendation = not self.take_recommendation
                    if self.take_recommendation:
                        self.output['recommendations'].append(value)
                        self.in_recommendation = False
                elif name == 'data-unallowed-docid':
                    self.output['id'] = value
                        
        elif (tag == 'a') and self.in_details:
            for name, value in attrs:
                if name == 'class' and value == 'document-subtitle primary':
                    self.in_author_id = True
                elif name == 'href':
                    if self.in_author_id:
                        self.output['author_id'] = value.split('id=')[1]
                        self.in_author_id = False
        elif (tag == 'span'):
            for name, value in attrs:
                if name == 'itemprop':
                    if value == 'genre':
                        self.in_genre = True
                    elif value == 'name':
                        self.in_name = True
        elif (tag == 'img'):
            for name, value in attrs:
                if self.in_details and name == 'class' and value == 'cover-image':
                    self.in_cover = True
                elif self.in_cover and name == 'src':
                    self.cover_tmp = value
                    self.in_cover = False
                elif name == 'itemprop':
                    if value == 'screenshot':
                        self.in_screenshot = True
                    elif value == 'image':
                        self.output['cover'] = self.cover_tmp
                elif self.in_screenshot and name == 'src':
                    self.output['screenshots'].append(value)
                    self.in_screenshot = False
        elif (tag == 'meta'):
            for name, value in attrs:
                if name == 'itemprop':
                    if value == 'offerType':
                        self.in_price = True
                    elif value == 'ratingValue':
                        self.in_rating = True
                    elif value == 'ratingCount':
                        self.in_votes = True
                elif name == 'content':
                    if self.in_price:
                        if value:
                            self.output['price'] = encodify(value)
                            self.in_price = False
                    elif self.in_rating:
                        if self.rating_set:
                            self.output['votes'] = value
                            self.in_rating = False
                        else:
                            self.output['rating'] = value
                            self.rating_set = True                     

                
    def handle_data(self, data): # this handles data inside of a tag. for example when you have <a>This is a link</a>, then this will handle the "This is the link" part.
        if self.in_description:
            print('description: '+data)
            self.output['description'] = encodify(data.strip())
            self.in_description = False
        elif self.in_genre:
            print('category: '+data)
            self.output['category'] = encodify(data.strip())
            self.in_genre = False
        elif (self.in_title == 2):
            print('title: '+data)
            self.output['name'] = encodify(data.strip())
            self.in_title = 0
        elif self.in_inapp_msg:
            print('msg: '+data)
            self.output['msg'] = encodify(data.strip())
            self.in_inapp_msg = False
        elif self.in_subtitle:
            print('subtitle: '+data)
            self.output['subtitle'] = encodify(data.strip())
        elif self.in_author and self.in_name:
            print('author: '+data)
            self.output['author'] = encodify(data.strip())
            self.in_name = False
        elif self.in_version:
            print('version: '+data)
            self.output['version'] = encodify(data.strip())
            self.in_version = False
        elif self.in_size:
            print('size: '+data)
            self.output['size'] = encodify(data.strip())
            self.in_size = False
        elif self.in_downloads:
            print('downloads: '+data)
            self.output['downloads'] = encodify(data.strip())
            self.in_downloads = False
        elif self.in_datepublished:
            print('date: '+data)
            self.output['date'] = encodify(data.strip())
            self.in_datepublished = False
        elif self.in_os:
            print('os: '+data)
            self.output['os'] = data.strip()
            self.in_os = False
        elif self.in_contentrating:
            print('contentrating: '+data)
            self.output['contentrating'] = data.strip()
            self.in_contentrating = False
        
    def handle_endtag(self, tag): # this function is called when an end tag (like </a> ) is encountered
        if self.in_author and not self.in_subtitle and (tag == 'div'):
            self.in_author = False
        elif self.in_subtitle:
            self.in_subtitle = False

def get(url):
    """
    Get the page.
    """
    resource = urllib.request.urlopen(url) # downloads the url
    return resource.read() # returns the url contents

def _get_apps(url):
    content = get(url)
    parser = AppsHTMLParser() # creates new object from the parser class
    parser.feed(str(content)) # inserts the downloaded content in the class
    #xmlstring = str(ET.tostring(parser.output, "utf-8").decode("utf-8")) # gets the generated xml
    return parser.output # returns the xml

def app(app_id, hl='en'):
    if app_id.startswith("market://"):
        url = "https://play.google.com/store/apps/"+app_id.split('rket://')[1]
    elif "play.google.com" in app_id:
        url = app_id
    else:
        url = ('https://play.google.com/store/apps/details?id=%s&hl=%s') % (app_id, hl)
    parser = AppHTMLParser(url) # creates new object from the parser class
#    parser.output['id'] = app_id
    return parser.output # returns the object


def leaderboard(identifier, category=None, start=0, num=24, hl="en"):
    if identifier not in ('topselling_paid', 'topselling_free'):
        raise Exception("identifier must be topselling_paid or topselling_free")

    url = 'https://play.google.com/store/apps'
    if category:
        if category not in CATEGORIES:
            raise Exception('%s not exists in category list' % category)
        url += "/category/" + str(category).upper()

    url += "/collection/%s?start=%s&num=%s&hl=%s" % (identifier, start, num, hl)

    return _get_apps(url)


def search(query, category='apps', page=0, num=24, hl="en"):
    start = (page*num)+1
    url = ('https://play.google.com/store/search'
           '?q=%s&start=%s&num=%s&hl=%s&c=%s') % (query, start, num, hl, category)
    return _get_apps(url)


def developer(developer, category='apps', start=0, num=24, hl="en"):
    url = ('https://play.google.com/store/apps/developer'
           '?id=%s&start=%s&num=%s&hl=%s') % (developer, start, num, hl)
    print(url)
    return _get_apps(url)

def encodify(string):
    return string.encode('latin1').decode('unicode_escape').encode('latin1').decode('utf8')

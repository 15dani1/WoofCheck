#use this script to scrape images from bing (seems to have better results than google search)
import requests
import urllib.request, urllib.error, urllib.parse
import json
import re
import sys
import os

#TODO: get rid of beautifulsoup parts, scale to 120 breeds x 70 images, check for duplicates

subscription_key = "76011ec1055441a583fc59d2686f4a60" #api key for bing image search api
search_url = "https://api.cognitive.microsoft.com/bing/v7.0/images/search"
headers = {"Ocp-Apim-Subscription-Key" : subscription_key}
params = {"q": "search_term", "count": 70, "imageType": "photo", "size": "medium"}
DIR = "test_images/"
images = []  #contains tuple of image_name, thumbnail_url, file_name

#returns Tuple of searchresults (json), directory_path
def get_search_results(breed_name):
    search_query = breed_name.replace(' ', '+') #replace whitespace with the '+' for searches
    search_query+= "+dog"
    params["q"] = search_query
    directory_path = os.path.join(DIR, breed_name)
    os.mkdir(directory_path)
    response = requests.get(search_url, headers=headers, params=params)
    response.raise_for_status()
    return (response.json(), directory_path)
    #search_results = response.json()

#takes image data and writes to the directory
def add_breed_images(path):
    for (image_name, url, file_name) in images:
        try:
            image_data = requests.get(url)
            image_data.raise_for_status()
            f = open(os.path.join(path, file_name), 'wb')
            f.write(image_data.content)
            f.close()
            #print ("hey we made it to here!")
        except Exception as e:
            print("Could not load image " + image_name)
            print(e)

if __name__ == "__main__": #main method
    breed_list = [f for f in os.listdir("dataset/Images")] 
    cnt = 0
    
    #iterate through each breed, getting the search results, creating directory for the breed, then writing image for each image result
    for breed in breed_list:
        (search_results, dir_name) = get_search_results(breed)
        for result in search_results["value"]:
            image_name = result["name"]
            thumbnail_url = result["thumbnailUrl"]
            file_name = breed + str(cnt) + "." + result["encodingFormat"]
            images.append((image_name, thumbnail_url, file_name))
            cnt+=1
        add_breed_images(dir_name)
        cnt = 0
        images.clear()  #clear list for next breed
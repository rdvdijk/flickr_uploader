# Flickr Uploader

This gem uploads photos in a folder to a [Flickr](http://www.flickr.com) photoset.

I created it to easily backup my entire photo collection to Flickr.

## Configuration

Create a folder named `.flickr-uploader` in your home folder, and create a Flickr configuration
file called `flickr.yml`.

Example configuration file:

    key: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    secret: "xxxxxxxxxxxxxxxx"
    token_cache: "/Users/jane/.flickr-uploader/token_cache.yml"

Create your own [application on Flickr](http://www.flickr.com/services/apps), and use the `key`
and `secret` of that application in the configuration above. Make sure that the `token_cache` value
points to a different file in the same folder (it is a file the [flickr-fu](https://github.com/commonthread/flickr_fu)
library uses to cache the authentication tokens).

## Authorization

You need to authorize the application once using:

    $ flickr-uploader authorize

Visit the URL shown on your screen and follow the instructions on Flickr.

## Uploading

Uploading should now be easy:

    $ flickr-uploader upload /path/to/your/folder

This will upload all the photos in that folder to a new photoset with the name of the folder (in
this case: `folder`).

If there are more than 500 photos in the folder, separate photosets are created on Flickr, to
accomodate Flickr's 500 photos per photoset limit.

## Improvements

Feel free to fork this project on [GitHub](http://github.com/rdvdijk/flickr_uploader) to add any
improvements.

(Something that's coming up is logging the speed of the upload.)

## License

Released under the MIT License.


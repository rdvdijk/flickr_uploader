# Flickr Uploader

This gem uploads photos in a folder to a Flickr photoset.

## Configuration

Create a folder named `.flickr-uploader` in your home folder, and create a Flickr configuration
file called `flickr.yml`.

Example configuration file:

    key: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    secret: "xxxxxxxxxxxxxxxx"
    token_cache: "/Users/jane/.flickr-uploader/token_cache.yml"

Create your own [application on Flickr](http://www.flickr.com/services/apps), and use the `key`
and `secret` of that application in the configuration above.

## Authorization

You need to authorize the application once using:

    $ flickr-uploader authorize

Visit the URL shown on your screen and follow the instructions on Flickr.

## Uploading

Uploading should now be easy:

    $ flickr-uploader upload /path/to/your/folder

This will upload all the photos in that folder to a new photoset with the name of the folder (in
this case: `folder`).

## License

Released under the MIT License.


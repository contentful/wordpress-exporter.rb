Wordpress to Contentful Exporter
=================

## Description
This adapter will allow you to extract content from a WordPress Blog and prepare it to be imported to [Contentful](https://wwww.contentful.com).

The following content will be extracted:

* Blog with posts
* Categories, tags and terms from custom taxonomies
* Attachments


## Installation

```bash
gem install wordpress-exporter
```

This will install the `wordpress-exporter` executable on your system.


## Setup
To extract the blog content you need to [export](http://en.support.wordpress.com/export/) it from the WordPress blog and save it as a XML file.

Further you need to define where the tool can find the XML file and the destination of the transformed content.
Create a `settings.yml` file and fill in the `data_dir` and `wordpress_xml_path`:

``` yaml
data_dir: PATH_TO_ALL_DATA
wordpress_xml_path: PATH_TO_XML/file.xml
```

To extract the content run:

```bash
wordpress-exporter --config-file settings.yml --extract-to-json
```

The result will be a directory structure with the WordPress content transformed into JSON files that are ready for import.

Use the [generic-importer](https://github.com/contentful/generic-importer.rb) to import your blog then to Contentful.

## Step by step

1. [Export](http://en.support.wordpress.com/export/) the content of the blog from WordPress and save it as XML file.
2. Create YAML file with settings (eg. settings.yml) and fill in the required parameters.
   The generated `content types`, `entries` and `assets` will be saved to the `data_dir`.
   We recommend you to use `wordpress_settings/wordpress_settings.yml` file in this repository

3. Extract the content from the XML file and generate the content model and JSON files for the import:

    ```bash
    wordpress-exporter --config-file settings.yml --extract-to-json
    ```
    If you want to create a different content model for your blog you can use `--omit-content-model`

    ```bash
    wordpress-exporter --config-file settings.yml --extract-to-json --omit-content-model
    ```

    It will only extract the content and store it as JSON, you need to take care about the content mapping yourself.
    See the [Contentful-importer](https://github.com/contentful/generic-importer.rb) for details on how this needs to be done.

4. (Optional). HTML markup can be converted to markdown:

    ```bash
    wordpress-exporter --config-file settings.yml --convert-markup
    ```
    This will only touch the content body of a blog post, other attributes will not be changed.

5. Create your content model from JSON:

    ```bash
    wordpress-exporter --config-file settings.yml  --create-contentful-model-from-json

    ```

6. Use the [contentful-importer](https://github.com/contentful/contentful-importer.rb) to import the content to [contentful.com](https://www.contentful.com)

7. Add you organization id and the access token to your `settings.yml`

8. Add the new created space id to your `settings.yml` file.

9. Now follow the steps (starting from step 3) of our [contentful-importer guide](https://github.com/contentful/contentful-importer.rb#step-by-step) to publish your content.

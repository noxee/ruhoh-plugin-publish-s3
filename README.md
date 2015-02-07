ruhoh-plugin-publish-s3
=======================

A [ruhoh](https://github.com/ruhoh/ruhoh.rb/) plugin to deploy the compiled site to [Amazon S3](http://aws.amazon.com/s3/).

Requirements
------------
* Valid Amazon S3 Service with a bucket configured to host a static website (See [Setting Up a Static Website](http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html)).
* AWS Access Keys (See [Managing Access Keys for your AWS Account](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html).

Installation
------------
1. Copy `s3.rb` to the `plugins/publish` directory of your ruhoh site installation or alternatively clone this repo and create a symlink to it in the `plugins/publish`
i.e. `ln -s /git/location/to/ruhoh-plugin-publish-s3 ruhoh-site/plugin/publish/s3`.
**NOTE:** You may need to create the `plugins/publish` directory if it doesn't already exist

2. Install `aws-sdk` gem and add it to the ruhoh site's Gemfile and run `bundle install`.

3. If one doesn't already exist create a `publish.json` in the root directory of the ruhoh site and add the following:
```
{
    "s3": {
        "bucket": "your_bucket_name"
    }
}
```

4. Either run the following commands before publish the website or add them to your `.profile` (if using Linux/OSX):
```
export AWS_REGION="[YOUR BUCKET'S REGION]"
export AWS_ACCESS_KEY_ID="[YOUR AWS ACCESS KEY]"
export AWS_SECRET_ACCESS_KEY="[YOUR AWS SECRET KEY]"
```

Usage
-----
1. To deploy your files to S3 run the following command from the ruhoh site's root directory:
```
bundle exec ruhoh publish s3
```
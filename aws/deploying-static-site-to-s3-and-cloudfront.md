# Deploying static site to S3 and Cloudfront

I own the shiyason.com domain.
I want to deploy blog to it.
I don't want to pay for server fee.

I generate blog using Astro.
I copy the blog so s3 using command line.
I setup Cloudfront.
I setup Cloudfront policies.

I access the site at cloudfront URL.
It works.

I change the DNS of shiyason.com to point CNAME .shiyason.com -> cloudfront distribution url.

I visit shiyason.com.
It doesn't work.

I get a 403 from cloudfront saying there is a configuration mistake.

I go back to cloudfront settings.
https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=ap-northeast-1#/distributions/E2NLD0VGZ2T5QK/edit

I add en entry in the list of "Alternate domain name (CNAME)"

"shiyason.com"

In "CustomSSL certificate" section, I follow the link to "Request Certificate"
https://us-east-1.console.aws.amazon.com/acm/home?region=us-east-1#/certificates/request

I create a certificate, with "DNS Validation"

I follow the instructions, (place CNAME key,value in DNS settings)
Certificate creation and validation succeeds.

Back in the "CustomSSL certificate" section. I link the newly created certificate.

Hit the save button.

Bingo! Site works now with HTTPS.

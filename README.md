# CBPWordPress

[![Version](http://cocoapod-badges.herokuapp.com/v/CBPWordPress/badge.png)](http://cocoadocs.org/docsets/CBPWordPress)
[![Platform](http://cocoapod-badges.herokuapp.com/p/CBPWordPress/badge.png)](http://cocoadocs.org/docsets/CBPWordPress)

`CBPWordPress` is a library to display content from a WordPress blog in your app.

## Requirements
You'll need to install and active the Broadsheet.ie fork of the [WP-JSON-API](https://github.com/Broadsheetie/wp-json-api) plugin in your WordPress installation.

## Installation

CBPWordPress is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "CBPWordPress"

## Usage

The example app included is the basis for the current live version of the Broadsheet.ie iOS app.
To run the example project; clone the repo, and run `pod install` from the Example directory.

### Pointing at your WordPress install
Before you can make any calls, you must start the client with the root URL of your API. 

    [CBPWordPressAPIClient rootURI:@"http://broadsheet.ie"];
    
### Fetching Recent Posts
To fetch the most recent posts, just create a `NSURLSessionDataTask` using the `fetchPostsWithParams:withBlock:` helper method:

    [NSURLSessionDataTask fetchPostsWithParams:@{@"page": @(1)}
                                     withBlock:^(CBPWordPressPostsContainer *data, NSError *error) {
                                        //Handle the result here
                                     }];

The parameters here can be:
- count: the number of posts to return
- page: the page number of results to return

## Contact

Karl Monaghan
- http://github.com/kmonaghan
- http://twitter.com/karlmonaghan
- karl.t.monaghan@gmail.com

## License

CBPWordPress is available under the MIT license. See the LICENSE file for more info.


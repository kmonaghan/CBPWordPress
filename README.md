# CBPWordPress

`CBPWordPress` is a library to display content from a WordPress blog in your app.

## Requirements
You'll need to install and activate the Broadsheet.ie fork of the [WP-JSON-API](https://github.com/Broadsheetie/wp-json-api) plugin in your WordPress installation.

## Installation

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

#### Podfile
```
pod 'CBPWordPress'
```

## Usage
Pointing the library at your own WordPress installation is trivial. The first call to the library should be to set the root URL for the API.
```
[CBPWordPressAPIClient rootURI:@"http://YOUR-API-URL"];
```
Once that is set, the calls to the API will use that URL.

### Fetching A List Of Posts
To get a list of posts, you use the `fetchPostsWithParams:withBlock:` method from the `NSURLSessionDataTask` category.

In the example below, the first page of the recent posts is retrieved and the posts assigned to an array.

```
__weak typeof(self) weakSelf = self;

[NSURLSessionDataTask fetchPostsWithParams:@{@"page": @(1)}
                                 withBlock:^(CBPWordPressPostsContainer *data, NSError *error) {
                                    if (error) {
                                        //Handle Error
                                        return;
                                    }

                                    __strong typeof(weakSelf) strongSelf = weakSelf;

                                    strongSelf.posts = data.posts;
}];
```

The allowed parameters are:
- page: The page you want to fetch. Starts at 1.
- count: The number of posts to retrieve. Defaults to 10.

### Fetching A Post
If you know the post id, you can fetch a post using the `fetchPostWithId:withBlock:` method from the `NSURLSessionDataTask` category. The example below fetches post 1234 and assigns it to a local post variable.

```
__weak typeof(self) weakSelf = self;

[NSURLSessionDataTask fetchPostWithId:1234
                            withBlock:^(CBPWordPressPost *post, NSError *error){
                                if (error) {
                                    //Handle Error
                                    return;
                                }

                                __strong typeof(weakSelf) strongSelf = weakSelf;

                                strongSelf.post = post;
}];

```

If you have the URL of the post, you can use the `fetchPostWithURL:withBlock:` method instead. You pass the full URL of the post as the parameter.

### Comment On A Post
To comment on a post, the `postComment:withBlock:` method from the `NSURLSessionDataTask` category is used. The method takes a CBPWordPressComment object as the first parameter. Below is an example comment being initialised.

```
CBPWordPressComment *newComment = [CBPWordPressComment new];
newComment.postId = 1234;
newComment.email = @"example@example.com";
newComment.name = @"Jonny Appleseed";
newComment.content = @"This is a comment!";
//Optional
newComment.url = @"http://somewebsite.com";
//If the comment is replying to another comment
newComment.parent = 1234;
```

Note that the URL and parent properties are optional but everything else is required. The parent property should be only be set if the user is replying to a comment and should be that comment's id.

Once the comment is initialised, pass it to the `postComment:withBlock:` method. In the following example, the new comment is submitted and on success is set to the returned comment object.

```
__weak typeof(self) weakSelf = self;

[NSURLSessionDataTask postComment:newComment
                        withBlock:^(CBPWordPressComment *comment, NSError *error){
                            __strong typeof(weakSelf) strongSelf = weakSelf;

                            if (error) {
                                //Handle error
                                return;
                            }

                            strongSelf.comment = newComment;
}];
```

[Known issue](https://github.com/kmonaghan/CBPWordPress/issues/9): if WordPress detects a duplicate comment, the resulting return is HTML rather than JSON.
<h2>To Do</h2>
The library is very much a work in progress. Some of the planned functionality to add is:
- Add option to fetch data from [WP-API](https://github.com/WP-API/WP-API) plugin
- Implement helper methods for each WP-JSON-API endpoint (get_category_posts, get_tag_posts etc.)
- Add a [Today Extension](http://www.karlmonaghan.com/2014/06/17/creating-an-ios-framework-and-today-extension/) to the example app

## Contributing
Contributions via pull requests and suggestions are welcome.

## Contact

Karl Monaghan
- http://github.com/kmonaghan
- http://twitter.com/karlmonaghan
- karl.t.monaghan@gmail.com

## License

CBPWordPress is available under the MIT license. See the LICENSE file for more info.


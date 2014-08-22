Pod::Spec.new do |s|
  s.name             = "CBPWordPress"
  s.version          = "0.1.0"
  s.summary          = "A library to display content from a WordPress blog."
  s.description      = <<-DESC
			CBPWordPress is an iOS library that will allow you to easily include content from a WordPress blog. The library can fetch lists of posts, individual posts and submit comments.

			The data is provided from your WordPress blog using the WP-JSON-API plugin.                        
DESC
  s.homepage         = "https://github.com/kmonaghan/CBPWordPress"
  s.license          = 'MIT'
  s.author           = { "Karl Monaghan" => "karl.t.monaghan@gmail.com" }
  s.source           = { :git => "https://github.com/kmonaghan/CBPWordPress.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/karlmonaghan'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'CBPWordPress/*.{h,m}'
  s.dependency 'AFNetworking', '~> 2.0.0'
end

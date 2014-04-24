Pod::Spec.new do |s|
  s.name             = "RPJSContext"
  s.version          = "0.1.0"
  s.summary          = "JSContext++"
  s.homepage         = "http://github.com/RobotsAndPencils/RPJSContext"
  s.license          = 'MIT'
  s.author           = { "Brandon Evans" => "brandon.evans@robotsandpencils.com" }
  s.source           = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RobotsNPencils'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.source_files = 'Classes/**/*'
  s.resources = 'Assets/JS/*.js'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'JavaScriptCore'
  s.dependency 'AFNetworking', '~>2.2'
end

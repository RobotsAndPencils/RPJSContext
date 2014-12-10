Pod::Spec.new do |s|
  s.name             = "RPJSContext"
  s.version          = "2.0.0"
  s.summary          = "JSContext++"
  s.homepage         = "http://github.com/RobotsAndPencils/RPJSContext"
  s.license          = 'MIT'
  s.author           = { "Brandon Evans" => "brandon.evans@robotsandpencils.com" }
  s.source           = { :git => "https://github.com/RobotsAndPencils/RPJSContext.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RobotsNPencils'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true

  s.source_files = 'Classes/**/*'
  s.resources = 'Assets/JS/**/*.js'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'JavaScriptCore'
  s.dependency 'AFNetworking', '~>2.2'
end

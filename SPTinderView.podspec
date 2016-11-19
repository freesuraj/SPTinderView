Pod::Spec.new do |s|
  s.name = 'SPTinderView'
  s.version = '0.5.0'
  s.license = 'MIT'
  s.summary = 'Tinder View written in Swift'
  s.homepage = 'https://github.com/freesuraj/SPTinderView'
  s.social_media_url = 'http://twitter.com/iosCook'
  s.authors = { 'Suraj Pathak' => 'freesuraj@gmail.com' }
  s.source = { :git => 'https://github.com/freesuraj/SPTinderView.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'SPTinderView/Source/*.swift'
  s.requires_arc = true
  s.screenshot = "https://github.com/freesuraj/SPTinderView/blob/master/assets/screenshot.gif?raw=true"
end

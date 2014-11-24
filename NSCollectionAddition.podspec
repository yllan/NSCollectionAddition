Pod::Spec.new do |s|
  s.name         = "NSCollectionAddition"
  s.version      = "1.0"
  s.summary      = "Categories with convenient methods of collection classes"
  s.description  = "NSCollectionAddition add some functional style methods to collections."
  s.homepage     = "https://github.com/yllan/NSCollectionAddition"
  s.license      = 'New BSD'
  s.author       = { "yllan" => "yllan@me.com" }
  s.source       = { :git => "https://github.com/yllan/NSCollectionAddition.git",
                     :tag => "1.0" }
  s.source_files = 'NSCollectionAddition/*.{h,m}'
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true
end

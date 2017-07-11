
Pod::Spec.new do |s|

  s.name          = "XYQPlayer"
  s.version       = "1.1.2"
  s.summary       = "A music and moive framework of XYQPlayer."
  s.homepage      = "https://github.com/xiayuanquan/XYQPlayer"
  s.license       = "MIT"
  s.author             = { "夏远全" => "13718037163@163.com" }
  s.platform      = :ios
  s.source        = { :git => "https://github.com/xiayuanquan/XYQPlayer.git", :tag => s.version }
  s.source_files  = "XYQPlayer/*.{h,m}"
  s.resources     = "XYQPlayer/Source.bundle/source/*.png"
  s.requires_arc  = true

end

Pod::Spec.new do |s|

  s.name         = "YUTableView"
  s.version      = "1.0"
  s.summary      = "Adds expandable sub-menu support to UITableView."
  s.homepage     = "https://github.com/ujell/YUTableView"
  s.license      = { :type => "MIT"}
  s.author       = { "yucel" => "yuceluzun@windowslive.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/ujell/YUTableView.git", :tag => "1.0" }
  s.source_files = "YUTableViewDemo/YUTableView/*.h,m"
  s.requires_arc = true

end

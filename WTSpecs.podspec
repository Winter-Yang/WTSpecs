Pod::Spec.new do |s|
  s.name             = 'WTSpecs'
  s.version          = '0.0.1'
  s.summary       = '杨雯德iOS组件库测试'
  s.homepage      = 'https://github.com/Winter-Yang/WTSpecs.git'
  s.license           = { :type => 'MIT', :file => 'LICENSE' }
  s.author            = { 'yangwende' => '17709215280@163.com' }
  s.source           = { :git => 'https://github.com/Winter-Yang/WTSpecs.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.requires_arc = true

  s.subspec 'QFQNetWork' do |sp|
  sp.source_files = 'Pod/Classes/QFQNetwork/**/*'
  sp.public_header_files = 'Pod/Classes/QFQNetwork/**/*.h'
  sp.dependency 'AFNetworking', '~> 3.1.0'
  end

  s.subspec 'QFQTools' do |sq|
  sq.source_files = 'Pod/Classes/QFQTools/**/*'
  sq.public_header_files = 'Pod/Classes/QFQTools/**/*.h'
  end
end
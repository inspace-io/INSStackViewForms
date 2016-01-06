Pod::Spec.new do |s|
  s.name     = 'INSStackViewForms'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = ''
  s.homepage = 'http://inspace.io'
  s.authors  = 'inspace.io'
  s.source   = { :git => 'https://github.com/inspace-io/INSStackViewForms.git', :tag => s.version.to_s }
  s.default_subspec = 'Core'
  s.requires_arc = true

  s.subspec "Core" do |sp| 
    sp.source_files = 'INSStackViewForms/*.{h,m}'
  end

  s.subspec "OAStackView" do |sp|
    sp.source_files = "INSStackViewForms/**/*.{h,m}"
    sp.dependency 'OAStackView'
    sp.platform = :ios, '8.0'
  end

  s.platform = :ios, '9.0'
  s.frameworks = 'UIKit'
end
Pod::Spec.new do |s|
  s.name     = 'INSStackViewForms'
  s.version  = '1.2.6'
  s.license  = 'MIT'
  s.summary  = 'INSStackViewForms - iOS library to create dynamic UIStackView forms'
  s.homepage = 'http://inspace.io'
  s.authors  = 'inspace.io'
  s.source   = { :git => 'https://github.com/inspace-io/INSStackViewForms.git', :tag => s.version.to_s }
  s.default_subspec = 'Core'
  s.requires_arc = true

  s.subspec "Core" do |sp| 
    sp.source_files = 'INSStackViewForms/**/*.{h,m}'
    sp.resource = 'INSStackViewForms/INSStackViewForms.bundle'
  end

  s.subspec "OAStackView" do |sp|
    sp.source_files = "INSStackViewForms/**/*.{h,m}"
    sp.dependency 'OAStackView'
    sp.platform = :ios, '7.0'
    sp.resource = 'INSStackViewForms/INSStackViewForms.bundle'
  end

  s.platform = :ios, '9.0'
  s.frameworks = 'UIKit'
end

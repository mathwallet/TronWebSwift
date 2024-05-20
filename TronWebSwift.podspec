Pod::Spec.new do |spec|
    spec.name = 'TronWebSwift'
    spec.version = '1.0.0'
    spec.summary = 'A Swift wrapper for Tron Web API'
    spec.description = <<-DESC
                         A Swift wrapper for Tron Web API to interact with Tron blockchain.
                         DESC
    spec.homepage = 'https://github.com/mathwallet/TronWebSwift'
    spec.license = { :type => 'MIT', :file => 'LICENSE' }
    spec.author = { 'Math Wallet' => 'support@mathwallet.org' }
  
    spec.requires_arc = true
    spec.source = { git: 'https://github.com/mathwallet/TronWebSwift.git', tag: '1.0.0' }
    spec.source_files = 'TronWebSwift/**/*.{h,m,swift}'
    spec.exclude_files = 'Sources/**/LinuxSupport.swift'
    spec.ios.deployment_target = '13.0'
    spec.swift_version = '5.0'
  
    spec.dependency 'Alamofire', '~> 5.4'
  end
  
#
#  Logue.podspec
#  Logue
#
#  Created by Jaehong Kang on 19/03/2019.
#  Copyright © 2019 Jaehong Kang. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#  http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

Pod::Spec.new do |s|
  s.name         = 'Logue'
  s.version      = '1.0.1'
  s.summary      = 'Lightweight, extensible logging framework.'

  s.description  = <<-DESC
                   Logue is lightweight, extensible logging framework.
                   DESC

  s.homepage     = 'https://github.com/sinoru/Logue'

  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.author       = { 'Jaehong Kang' => 'sinoru@me.com' }

  s.macos.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.swift_version = '4.2'

  s.subspec 'Core' do |ss|
    ss.source_files  = 'Sources/Logue/*.{swift}'
    ss.frameworks = 'Foundation'
  end

  s.subspec 'Loggers' do |ss|
    ss.source_files  = 'Sources/Loggers/*.{swift}'
    ss.frameworks = 'Foundation'
    ss.dependency 'Logue/Core'
  end

  s.default_subspecs = 'Core', 'Loggers'
  s.source       = { :git => 'https://github.com/sinoru/Logue.git', :tag => s.version.to_s }
end

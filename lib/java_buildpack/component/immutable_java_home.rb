# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'java_buildpack/component'

module JavaBuildpack::Component

  # An abstraction around the +JAVA_HOME+ path used by the droplet.  This implementation is immutable and should be
  # passed to any component that is not a jre.
  #
  # A new instance of this type should be created once for the application.
  class ImmutableJavaHome

    # Creates a new instance of the java home abstraction
    #
    # @param [MutableJavaHome] delegate the instance of +MutableJavaHome+ to use as a delegate for +root+ calls
    def initialize(delegate)
      @delegate = delegate
    end

    # Returns the path of +JAVA_HOME+ as an environment variable formatted as +JAVA_HOME="$PWD/<value>"+
    #
    # @return [String] the path of +JAVA_HOME+ as an environment variable
    def as_env_var
      "JAVA_HOME=#{root}"
    end

    # Execute a block with the +JAVA_HOME+ environment variable set
    #
    # @yield yields to block with the +JAVA_HOME+ environment variable set
    def do_with
      previous_value = ENV['JAVA_HOME']
      begin
        ENV['JAVA_HOME'] = root
        yield
      ensure
        ENV['JAVA_HOME'] = previous_value
      end
    end

    # @return [String] the root of the droplet's +JAVA_HOME+
    def root
      @delegate.root
    end

  end

end

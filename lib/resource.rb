require 'hashie'

class Resource < Hash
  include Hashie::Extensions::IndifferentAccess
  include Hashie::Extensions::MergeInitializer
  include Hashie::Extensions::MethodAccess
end

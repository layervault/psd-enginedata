class PSD
  class EngineData
    class Node < Hash
      include Hashie::Extensions::MergeInitializer
      include Hashie::Extensions::MethodAccess
    end
  end
end

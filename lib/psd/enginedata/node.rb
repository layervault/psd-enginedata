class PSD
  class EngineData
    # Represents a single node in the parsing tree. Extended with Hashie methods
    # to make data access easier.
    class Node < Hash
      include Hashie::Extensions::MergeInitializer
      include Hashie::Extensions::MethodAccess
    end
  end
end

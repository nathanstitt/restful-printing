module Printing

    class JsonModel

        include Virtus

        def to_json(*a)
            self.to_hash
        end

    end

end

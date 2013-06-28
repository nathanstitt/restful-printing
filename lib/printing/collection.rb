module Printing

class Collection < Array

    def to_json(*a)
        self.map{|obj| obj.to_json(*a)}
    end

end

end

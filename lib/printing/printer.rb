require 'tempfile'

module Printing

    class PrinterCollection < Collection
    end

    class Printer < JsonModel

        attribute :name, String

        def jobs
            Cups.all_jobs( name ).inject(JobCollection.new) do | jc, data |
                jc.push Job.new( :id=>data.first, :data=>data.last )
            end
        end

        def self.available
            Cups.show_destinations.inject(PrinterCollection.new) do | pc, name |
                pc.push Printer.new({ :name=>name })
            end
        end

    end

end

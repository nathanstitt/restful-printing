require 'curb'

module Printing

    class JobCollection < Collection
    end

    class Job < JsonModel

        attribute :id, String
        attribute :data, Hash
        attribute :url, String
        attribute :title, String
        attribute :data, String

        attribute :job_id, Fixnum
        attribute :printer

        def exists?
            ! self.state.nil?
        end

        def state
            return @state unless @state.nil?
            pj = Cups::PrintJob.new( '', printer.name )
            pj.job_id = job_id
            @state = pj.state
        end

        def send_to( printer )
            return self if @job
            tf = Tempfile.new('print-job')
            tf.write read_data
            tf.close
            @job = Cups::PrintJob.new( tf.path, printer.name )
            @job.title = self.title || 'Remote Print Job'
            @job.print
            self.job_id = @job.job_id
            tf.unlink
            self
        end

        private

        def read_data
            if self.url
                Curl.get( self.url ).body_str
            elsif self.data
                self.data
            else
                raise 'no data present'
            end
        end

    end


end

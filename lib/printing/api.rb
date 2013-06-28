module Printing

    class API < Grape::API

        format :json

        namespace :printers do
            desc "All available printers"
            get do
                Printer.available
            end

            namespace ":name" do

                namespace "jobs" do

                    desc "All jobs for printer :name"
                    get do
                        Printer.new(:name=>params[:name]).jobs
                    end

                    desc "Create new print job for printer :name.  Must have either a :url, or :data parameter specified"
                    post do
                        printer = Printer.new( :name=>params.name )
                        valid = %w{ data url }
                        attrs = params.to_h.select{ |key, value| valid.include?(key) }
                        p params
                        p attrs

                        job = Job.new( attrs )

                        job.title = params.title if params.title?
                        job.send_to(printer)
                    end

                    desc "return data associated with a job (currently only it's status is reported)"
                    namespace ":job_id" do
                        get do
                            printer = Printer.new( :name=>params.name )
                            job = Job.new({ :job_id=>params.job_id, :printer=>printer } )
                            if job.exists?
                                { 'state' => job.state }
                            else
                                { :success=>false, :message => "job-not-found" }
                            end
                        end
                    end

                end

            end

        end

    end

end

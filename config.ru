require 'grape'
require 'rack/cors'
require './lib/printing'

use Rack::Cors do
    allow do
        origins '*'
        resource '*', headers: :any, methods: :get
    end
end

puts "Starting up RestfulPrinting, routes are: "
Printing::API::routes.each do |rt|
    puts ' * ' + rt.route_description + ':'
    puts '   * ' + rt.route_method + ' ' + rt.route_path
    puts
end
run Printing::API

require "./config/environment.rb"

use Rack::MethodOverride
use UserController
use ItemController
run ApplicationController
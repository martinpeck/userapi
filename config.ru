$LOAD_PATH << "./lib"

require "codeclub/server"
run Codeclub::Server::App.new
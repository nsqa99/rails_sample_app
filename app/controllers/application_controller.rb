class ApplicationController < ActionController::Base
    def hello
        render html: "Running on Rails..."
    end
end

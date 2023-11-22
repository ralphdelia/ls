ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative "../cms"

class CMSTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"

    assert_equal 200, last_response.status

    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "about.md"
    assert_includes last_response.body, "changes.txt"
    assert_includes last_response.body, "history.txt"
  end

  def test_viewing_text_document
    get "/history.txt"

    assert_equal 200, last_response.status
    assert_equal "text/plain", last_response["Content-Type"]
    assert_includes(last_response.body, 'History')
  end

  def test_document_not_found
    get "/notafile.ext" 
  
    assert_equal 302, last_response.status 
  
    get last_response["Location"] 
  
    assert_equal 200, last_response.status
    assert_includes last_response.body, "notafile.ext does not exist"
  
    get "/" 
    refute_includes last_response.body, "notafile.ext does not exist"
  end

  def test_markdown
    get '/about.md'

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, 'Ruby is...'

    get '/history.txt'
    assert_equal 'text/plain', last_response["Content-Type"]

  end

end
__END__

in our test we can use -
  get and post

use last response with 'last_response'
  (instance of Rack::MockResponse)
  methods 
    - status, status code
    - body, content
    - [], headers
  
use these methods to make assseritons agains our test results

Flash message through session data
  create a message that will be put at the top of the document 
  make the message conditional
  make the message delete itself 

in our application code
  make a not found method
  creates an error message
    in seesion data 
  redirects to the index 
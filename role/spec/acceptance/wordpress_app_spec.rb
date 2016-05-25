require 'net/http'
require 'net/https'

describe 'wordpress application' do
  it 'should respond with 302 redirect to web based installer' do
    url = ENV['ACCEPTANCE_WORDPRESS_URL']

    uri = URI.parse(url)
    http = Net::HTTP.new( uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
  
    expect(response.code).to eq("302")
    expect(response['location']).to eq("#{url}/wp-admin/install.php")
  end
end

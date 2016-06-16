Bundler.require(:default, :test)

describe 'puppet files' do
  it 'should parse successfully' do
    `find . -type f -name '*.pp' | xargs puppet parser validate --app_management`
    expect($?.exitstatus).to equal(0)
  end
end

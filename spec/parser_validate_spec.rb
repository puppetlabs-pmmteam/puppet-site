describe 'puppet files' do
  it 'should parse successfully' do
    `find . -type f -name '*.pp' | xargs puppet parser validate`
    expect($?.exitstatus).to equal(0)
  end
end

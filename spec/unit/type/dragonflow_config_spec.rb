require 'puppet'
require 'puppet/type/dragonflow_config'
describe 'Puppet::Type.type(:dragonflow_config)' do
  before :each do
    @dragonflow_config = Puppet::Type.type(:dragonflow_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:dragonflow_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:dragonflow_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:dragonflow_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:dragonflow_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @dragonflow_config[:value] = 'bar'
    expect(@dragonflow_config[:value]).to eq('bar')
  end

  it 'should not accept a value with whitespace' do
    @dragonflow_config[:value] = 'b ar'
    expect(@dragonflow_config[:value]).to eq('b ar')
  end

  it 'should accept valid ensure values' do
    @dragonflow_config[:ensure] = :present
    expect(@dragonflow_config[:ensure]).to eq(:present)
    @dragonflow_config[:ensure] = :absent
    expect(@dragonflow_config[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @dragonflow_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    package = Puppet::Type.type(:package).new(:name => 'dragonflow')
    catalog.add_resource package, @dragonflow_config
    dependency = @dragonflow_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@dragonflow_config)
    expect(dependency[0].source).to eq(package)
  end


end

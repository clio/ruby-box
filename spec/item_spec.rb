#encoding: UTF-8

require 'ruby-box'
require 'webmock/rspec'

describe RubyBox::Item do

  before do
    @session = RubyBox::Session.new
    @client  = RubyBox::Client.new(@session)
  end

  describe '#factory' do
    
    it 'creates an object from a web_link hash' do
      web_link = RubyBox::Item.factory(@session, {
        'type' => 'web_link'
      })
      web_link.type.should == 'web_link'
      web_link.instance_of?(RubyBox::WebLink).should == true
    end

    it 'defaults to item object if unknown type' do
      banana = RubyBox::Item.factory(@session, {
        'type' => 'banana'
      })
      banana.type.should == 'banana'
      banana.instance_of?(RubyBox::Item).should == true
    end
  end

  describe '#move_to' do
    let(:source_folder) { RubyBox::Item.new(@session, {'id' => 1, 'etag' => '0' }) }
    let(:destination)   { RubyBox::Item.new(@session, {'id' => 100, 'etag' => '0' }) }
    let(:last_request) { JSON.parse(@request.body) }
    let(:last_uri) { @uri.to_s }

    before(:each) do
      @session.stub(:request).with do |uri, request, _, _|
        @uri, @request = uri, request
      end
    end

    it 'does not include name in the request' do
      source_folder.move_to destination.id
      last_request.should_not have_key 'name'
    end
  end
end

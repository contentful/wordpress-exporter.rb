require 'spec_helper'
require './lib/wordpress/post'
require './lib/wordpress/blog'
require './lib/wordpress/post_attachment'

module Contentful
  module Exporter
    module Wordpress
      describe PostAttachment do
        before do
          xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          @items = xml_doc.search('item')
          @post = PostAttachment.new(@items[-2], @settings)
        end

        it 'can extract the url of an attachment' do
          url = @post.send(:attachment_url)

          expect(url).to eq 'https://szpryc.files.wordpress.com/2014/11/screen-shot-2014-11-27-at-12-34-47-pm.png'
        end

        it 'can extract the id of an attachment' do
          id = @post.send(:attachment_id)

          expect(id).to eq 'attachment_post_15'
        end

        it 'can extract the description of an attachment' do
          description = @post.send(:attachment_description)

          expect(description).to eq 'MOJ_DESC'
        end

        it 'is resilient against missing wp:meta_keys' do
          @post = PostAttachment.new(@items.last, @settings)
          description = @post.send(:attachment_description)

          expect(description).to eq ''
        end

        it 'is resilient against missing _wp_attachment_image_alt' do
          @post = PostAttachment.new(@items[2], @settings)
          description = @post.send(:attachment_description)

          expect(description).to eq ''
        end
      end
    end
  end
end
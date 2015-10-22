require 'spec_helper'
require './lib/wordpress/post'
require './lib/wordpress/blog'
require './lib/wordpress/post_attachment'
require './lib/wordpress/post_category_domain'

module Contentful
  module Exporter
    module Wordpress
      describe Post do
        include_context 'shared_configuration'

        before do
          @xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          @post = Post.new(@xml_doc, @settings)
        end

        it 'initialize' do
          expect(@post.settings).to be_kind_of Contentful::Configuration
          expect(@post.xml).to be_kind_of Nokogiri::XML::Document
        end

        describe 'extract_data' do
          it 'extracts data from correctly formed xml' do
            post_xml = @xml_doc.xpath('//item').to_a.first
            post = @post.send(:extract_data, post_xml)
            expect(post.count).to eq 5
            expect(post[:id]).to eq 'post_1'
            expect(post[:title]).to eq 'Informacje'
            expect(post[:wordpress_url]).to eq 'http://szpryc.wordpress.com/informacje/'
            expect(post[:created_at]).to eq Date.parse('2014-11-26')
          end

          it 'extracts :created_at as Date.today when wp:post_date and wp:post_date_gmt are missing' do
            xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress_empty_dates.xml'))
            post_xml = xml_doc.xpath('//item').to_a.first

            expect_any_instance_of(Logger).to receive(:warn).with("Post <post_1> didn't have Creation Date - defaulting to #{Date.today}")

            post = Post.new(xml_doc, @settings).send(:extract_data, post_xml)

            expect(post[:created_at]).to eq Date.today
          end

          it 'tries to fetch :created_at from wp:post_date_gmt if wp:post_date is missing' do
            xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress_empty_dates.xml'))
            post_xml = xml_doc.xpath('//item').to_a[1]
            post = Post.new(xml_doc, @settings).send(:extract_data, post_xml)

            expect(post[:created_at]).to eq Date.parse('2015-06-20')
          end
        end

        it 'post_id(post)' do
          post = @xml_doc.xpath('//item').to_a.first
          post_id = @post.post_id(post)
          expect(post_id).to eq 'post_1'
        end
      end
    end
  end
end

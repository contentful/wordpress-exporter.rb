require 'spec_helper'
require './lib/wordpress/author'
require './lib/wordpress/blog'

module Contentful
  module Exporter
    module Wordpress
      describe Author do
        include_context 'shared_configuration'

        before do
          xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          @author = Author.new(xml_doc, @settings)
        end

        it 'initialize' do
          expect(@author.settings).to be_kind_of Contentful::Configuration
          expect(@author.xml).to be_kind_of Nokogiri::XML::Document
        end

        it 'extract_authors' do
          authors = @author.send(:extract_authors)
          expect(authors).to be_kind_of Array
          expect(authors.count).to eq 2
          expect(authors.first).to include(id: 'author_10',
                                           email: 'komarpro@gmail.com',
                                           display_name: 'szpryc',
                                           first_name: '',
                                           last_name: '',
                                           wordpress_login: 'szpryc')
          expect(authors.last).to include(id: 'author_12',
                                          email: 'testy.testerson@gmail.com',
                                          display_name: 'Testy Testerson',
                                          first_name: 'Testy',
                                          last_name: 'Testerson',
                                          wordpress_login: 'testytesterson')
        end

        it 'extracted_data' do
          authors_xml = @author.xml.xpath('//wp:author').to_a
          author = @author.send(:extracted_data, authors_xml.last)
          expect(author).to be_kind_of Hash
          expect(author.count).to eq 6
          expect(author).to include(id: 'author_12',
                                    email: 'testy.testerson@gmail.com',
                                    display_name: 'Testy Testerson',
                                    first_name: 'Testy',
                                    last_name: 'Testerson',
                                    wordpress_login: 'testytesterson')
        end
      end
    end
  end
end

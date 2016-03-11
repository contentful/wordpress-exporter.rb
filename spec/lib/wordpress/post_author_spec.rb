require 'spec_helper'
require './lib/wordpress/post_author'
require './lib/wordpress/post'
require './lib/wordpress/blog'

module Contentful
  module Exporter
    module Wordpress
      describe PostAuthor do
        include_context 'shared_configuration'

        before do
          xml_doc = Nokogiri::XML(File.open('spec/fixtures/wordpress.xml'))
          post = xml_doc.xpath('//item').to_a[4]
          @p_author = PostAuthor.new(xml_doc, post, @settings)
        end

        it 'initialize' do
          expect(@p_author.settings).to be_kind_of Contentful::Configuration
          expect(@p_author.xml).to be_kind_of Nokogiri::XML::Document
        end

        it 'extract_author' do
          author = @p_author.send(:author_extractor)
          expect(author).to be_kind_of Hash
          expect(author[:id]).to eq 'author_10'
        end
      end
    end
  end
end

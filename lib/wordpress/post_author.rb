require_relative 'post'

module Contentful
  module Exporter
    module Wordpress
      class PostAuthor < Post
        attr_reader :post, :xml, :settings

        def initialize(xml, post, settings)
          @xml = xml
          @post = post
          @settings = settings
        end

        def author_extractor
          output_logger.info 'Extracting post author...'
          { id: author_id }
        end

        private

        def author_id
          "author_#{author_id_by_login(author_login)}"
        end

        def author_id_by_login(login)
          xml.xpath("//wp:author[wp:author_login=\"#{login}\"]/wp:author_id").text
        end

        def author_login
          post.at_xpath('dc:creator').text
        end
      end
    end
  end
end

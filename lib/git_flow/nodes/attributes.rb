module GitFlow
  module Nodes
    # Methods for querying and manipulating the metadata attributes of the node
    module Attributes

      module ClassMethods
        # Recursive sorting algorithm for hash, array, value nest structures
        def sorted_attributes(attributes)
          if attributes.is_a? Hash
            attributes.keys.sort.inject({}) do |memo, key|
              memo[key] = sorted_attributes( attributes[key] )
              memo
            end
          elsif attributes.is_a? Array
            # Do not sort an array if the entries are not comparable
            attributes.each do |attribute|
              unless attribute.class.included_modules.include? Comparable
                return attributes.map { |value| sorted_attributes( value ) }
              end
            end
            attributes.sort.map { |value| sorted_attributes( value ) }
          else
            attributes
          end
        end
      end

      module InstanceMethods
        # Retrieves the attributes of this node
        # YAML contents of node are parsed from frontmatter and returned as a hash
        def attributes
          return @attributes unless @attributes.nil?
          @attributes =
          if root?
            { "title" => "/" }
          elsif exists? || content.present?
            extract_front_matter
            attributes
          else
            { }
          end
        end

        # Retrieves text content of this node
        # YAML frontmatter is removed and returned as string
        def text
          return @text unless @text.nil?
          if exists? || content.present?
            extract_front_matter
          else
            @text = ''
          end
          text
        end

        def text=( t )
          @text = t
        end

        # Returns attributes sorted
        # Useful for writing attributes in predictable order
        def sorted_attributes
          self.class.sorted_attributes attributes
        end

        # Returns sorted_attributes as JSON content suitable to write to file
        def attributes_to_content
          self.content = "#{YAML.dump( sorted_attributes )}---\n#{text}"
        end

        # Set attribute values from hash
        def attributes=(values)
          attributes.merge! values
          attributes
        end

        # The type of this node
        def node_type
          return @node_type unless @node_type.nil?
          @node_type =
          if root?
            { title: true }
          elsif attributes["type"]
            allowed_node_types.find { |type| type["label"] == attributes["type"] }
          elsif allowed_node_types.length == 1
            allowed_node_types.first
          else
            false
          end
        end

        # Get the properly formatted number for this node
        def node_number
          return unless node_type && attributes["number"]
          number = attributes["number"].to_i
          case node_type["number"]
          when 'R'
            number.to_roman
          when 'r'
            number.to_roman.downcase
          when 'A'
            number.to_alpha.upcase
          when 'a'
            number.to_alpha
          else
            number
          end
        end

        # Render the label for the node type
        def node_label
          node_type['label']
        end

        # Render the full title of the node
        def node_title
          title = node_number ? "#{node_label.capitalize} #{node_number}. " : ""
          title = "#{title}#{attributes['title']}" if attributes['title']
          title
        end

        # Short title for node
        def node_short_title
          if node_number
            "#{node_label.capitalize} #{node_number}"
          else
            "#{attributes['title']}"
          end
        end

        # Render titles of parent nodes
        def node_title_context
          ancestor_nodes.reject(&:root?).reject { |ancestor|
            ancestor.tree == tree
          }.map(&:node_short_title).join(', ')
        end

        private

        def extract_front_matter
          @attributes, @text = YAML::FrontMatter.extract content
        end
      end
    end
  end
end

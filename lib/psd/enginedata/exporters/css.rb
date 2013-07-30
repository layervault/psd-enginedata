# -*- encoding : utf-8 -*-
class PSD
  class EngineData
    module Export
      # Exports the document to a CSS string.
      module CSS
        # Creates the CSS string and returns it. Each property is newline separated
        # and not all properties may be present depending on the document.
        #
        # Colors are returned in rgba() format and fonts may include some internal
        # Photoshop fonts.
        def to_css
          parse! unless parsed?
          
          definition = {}
          definition.merge! font_family
          definition.merge! font_size
          definition.merge! font_color

          css = []
          definition.each do |k, v|
            css << "#{k}: #{v};"
          end

          css.join("\n")
        end

        private

        def font_family
          font = result.ResourceDict.FontSet.map { |f| %{"#{f.Name}"} }.join(', ')

          {
            'font-family' => font
          }
        end

        def font_size
          {
            'font-size' => "#{styles.FontSize}pt"
          }
        end

        def font_color
          return {} unless styles.key?('FillColor')

          color = styles.FillColor.Values.map { |c| (c * 255).round }
          if color.length == 3
            alpha = 255
          else
            alpha = color.shift
          end

          {
            'color' => "rgba(#{color.join(', ')}, #{alpha})"
          }
        end

        def styles
          result.EngineDict.StyleRun.RunArray[0].StyleSheet.StyleSheetData
        end
      end
    end
  end
end

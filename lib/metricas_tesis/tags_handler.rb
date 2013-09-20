require 'date'
module MetricasTesis
  class TagsHandler
    def initialize path_to_repo
      @path_to_repo = path_to_repo
    end

    # Devuelve una lista con todos los tags
    def get_tags fecha_desde=nil, fecha_hasta=nil

      # tags= `git --git-dir='#{@path_to_repo}' tag`.split
      tags_con_fechas = `git --git-dir='#{@path_to_repo}' tag | xargs -I@ git --git-dir='#{@path_to_repo}' log --format=format:"%ai @%n" -1 @ | sort`.split("\n")

      # lo convierto a hash del estilo: tag => fecha
      temp_array = Array.new
      tags_con_fechas.each { |elem| elem.gsub(/^(.*)\s(\S+)$/) {|match| temp_array << $2; temp_array << Date.parse($1)} }
      
      hash_tag_to_fechas = Hash[*temp_array]

      tags_filtrados = Array.new

      
      if (nil == fecha_desde && nil == fecha_hasta)
        # no filtro nada
        tags_filtrados = hash_tag_to_fechas.keys
      else
        hash_tag_to_fechas.keys.each do |key|
          
          if hash_tag_to_fechas[key] >= fecha_desde && hash_tag_to_fechas[key] <= fecha_hasta
            tags_filtrados << key
          end
        end
      end


      tags_filtrados
    end


  end
end

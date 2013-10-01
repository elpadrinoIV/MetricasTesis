require 'archivos_commits_handler'
require 'normalizador_archivos_java'
module MetricasTesis
  class AnalizadorModificacionesJava
    def initialize path_repos
      @path_repos = path_repos
      @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new(path_repos)
      @normalizador_archivos_java = MetricasTesis::NormalizadorArchivosJava.new
    end

    def archivos_con_cambios_no_triviales commit_hash
      cantidad_archivos_modificados = 0
      archivos_modificados = @archivos_commits_handler.get_archivos_de_lista([commit_hash], ['M'])
      archivos_modificados[commit_hash].each do |archivo|
        archivo.gsub!(/^M\s*/,'')
        
        cantidad_archivos_modificados += 1 if hay_cambio_no_trivial?(archivo, commit_hash)
      end
      
      cantidad_archivos_modificados
    end

    def hay_cambio_no_trivial? archivo, commit_hash
      archivo_version_anterior = `git show #{commit_hash}^:#{archivo}`.split("\n")
      archivo_version_nueva = `git show #{commit_hash}:#{archivo}`.split("\n")

      archivo_version_anterior = @normalizador_archivos_java.normalizar(archivo_version_anterior)
      archivo_version_nueva = @normalizador_archivos_java.normalizar(archivo_version_nueva)

      # Guardo los archivos temporalmente
      File.open('__TEMP__VERSION_ANTERIOR', 'w') do |file|
        archivo_version_anterior.each {|linea| file.write(linea + "\n")}
      end

      File.open('__TEMP__VERSION_NUEVA', 'w') do |file|
        archivo_version_nueva.each {|linea| file.write(linea + "\n")}
      end

      `diff  --ignore-all-space --ignore-blank-lines __TEMP__VERSION_ANTERIOR __TEMP__VERSION_NUEVA`; hay_diferencias=$?.success?
      File.delete('__TEMP__VERSION_ANTERIOR')
      File.delete('__TEMP__VERSION_NUEVA')

      # diff arroja 0 cuando no hay diferencias y 1 cuando hay diferencias,
      # por eso lo niego.
      hay_diferencias = !hay_diferencias

      hay_diferencias
    end
  end

end

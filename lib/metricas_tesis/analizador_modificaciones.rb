require 'normalizador_archivos_java'
require 'normalizador_archivos_default'
require 'archivos_commits_handler'

module MetricasTesis
  class AnalizadorModificaciones
    def initialize path_repos
      @path_repos = path_repos
      @archivos_commits_handler = MetricasTesis::ArchivosCommitsHandler.new(path_repos)
      inicializar_mapa_normalizadores()
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
      archivo_version_anterior = `git --git-dir='#{@path_repos}' show #{commit_hash}^:#{archivo}`.force_encoding('BINARY').split("\n")
      archivo_version_nueva = `git --git-dir='#{@path_repos}' show #{commit_hash}:#{archivo}`.force_encoding('BINARY').split("\n")

      normalizador = obtener_normalizador(archivo)
      archivo_version_anterior = normalizador.normalizar(archivo_version_anterior)
      archivo_version_nueva = normalizador.normalizar(archivo_version_nueva)

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


    private
    def inicializar_mapa_normalizadores
      @mapa_normalizadores = Hash.new
      @mapa_normalizadores['java'] = MetricasTesis::NormalizadorArchivosJava.new
      @mapa_normalizadores['default'] = MetricasTesis::NormalizadorArchivosDefault.new
    end

    def obtener_normalizador archivo
      extension = archivo.gsub(/^.*\./, '')
      normalizador = @mapa_normalizadores['default']

      if @mapa_normalizadores.has_key?(extension)
        normalizador = @mapa_normalizadores[extension]
      end

      normalizador
    end
  end
end
require 'test/unit'
# require File.dirname(__FILE__) + '/../lib/metricas_tesis'
%w[metricas_tesis].each{ |libreria|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../lib/#{libreria}"))
}



# encoding: utf-8

# -----------------
# Introdução
# -----------------

# O objetivo deste exercício é avaliar como o desempenho de um determinado
# programa ou trecho de código varia de acordo com o número de threads
# utilizadas.

# Vamos avaliar o uso de threads em dois tipos de programa: o primeiro é do tipo
# "IO-intensive", isto é, um programa que gasta a maior parte do tempo em
# execuções de I/O (entrada e saída), como fazer o download de arquivos da
# Internet.

# O segundo programa é do tipo "CPU-intensive", isto é, um programa que gasta a
# maior parte do tempo fazendo cálculos (utilizando o processador).

# Para cada um destes programas, você deverá escrever três versões dele:
# 1) Uma versão sequencial (que não usa threads)
# 2) Uma versão que usa um número pequeno de threads
# 3) Uma versão que usa um número muito grande de threads

# A biblioteca de benchmark do Ruby
# (http://ruby-doc.org/stdlib-1.9.2/libdoc/benchmark/rdoc/Benchmark.html)
# será utilizada para comparar o desempenho destas diferentes versões.

# -----------------
# Exercício 6.4
# -----------------

# Importa a biblioteca de benchmark do Ruby
require 'benchmark'
require 'mechanize'

# Cada versão será executada N vezes, para garantir condições médias de
# desempenho.
N = 50_000

def links

  # Esta função baixa todos os links desta página:
  # http://en.wikipedia.org/wiki/List_of_programming_languages

  # Vamos utilizar uma biblioteca chamada Mechanize para fazer download
  # dos links.

  m = Mechanize.new

  # Baixa a página principal, que tem todos os links.
  m.get('http://en.wikipedia.org/wiki/List_of_programming_languages')

  links = m.page.links.
    map { |link| link.href }.
    select { |path| path =~ /\A\/wiki/ }.
    map { |path| "http://en.wikipedia.org/#{path}" }
  links[0..200]
end

def io_v1
  # Versão sequencial do programa IO-intensive.
  # Escreva aqui uma função que itera sobre os links retornados pela
  # função links e usa o Mechanize para baixar cada link.
  # Utilize uma nova instância do Mechanize por iteração.
  puts "Versao sequencial"
  vetor = links
  for elemento in vetor
    aux = Mechanize.new
    aux.get("#{elemento}")
  end
end

def io_v2
  # Versão do IO-intensive com 10 threads.
  puts "Versao 10 treads"
  threads = [] 
  vetor = links
  aux = Mechanize.new

  10.times do |i|

   t = Thread.new { 
      aux.get("#{vetor[i]}")
      aux.get("#{vetor[10+i]}")
      aux.get("#{vetor[20+i]}")
      aux.get("#{vetor[30+i]}")
      aux.get("#{vetor[40+i]}")
      aux.get("#{vetor[50+i]}")
      aux.get("#{vetor[60+i]}")
      aux.get("#{vetor[70+i]}")
      aux.get("#{vetor[80+i]}")
      aux.get("#{vetor[90+i]}")
   } 

   threads << t 

  end 

  threads.each { |t| t.join }
end

def io_v3
  # Versão do IO-intensive com 100 threads.
  puts "Versao 100 treads"
  threads = [] 
  vetor = links
  aux = Mechanize.new

  100.times do |i| 

   t = Thread.new { 
      aux.get("#{vetor[i]}")
   } 

   threads << t 

  end 

  threads.each { |t| t.join }
end

def sum(n)
  500_000.downto(n).reduce(:+)
end

def cpu_v1
  # Versão sequencial do programa CPU-intensive.
  # Escreva uma função que chama a função sum(n) para todos os inteiros
  # entre 0 e 100.
  puts "Versao sequencial"
  for i in 0..100
    sum(i)
  end
end

def cpu_v2
  # Versão do CPU-intensive com 10 threads.
  puts "Versao 10 treads"
  threads = [] 

  10.times do |n|

    t = Thread.new{
      sum(n)
      sum(n+10)
      sum(n+20)
      sum(n+30)
      sum(n+40)
      sum(n+50)
      sum(n+60)
      sum(n+70)
      sum(n+80)
      sum(n+90)
    }
    threads << t 
  end

  threads.each { |t| t.join }
end

def cpu_v3
  # Versão do CPU-intensive com 100 threads.
  puts "Versao 100 treads"
  threads = [] 

  100.times do |n|
    t = Thread.new{
      sum(n)
    }
    threads << t 
  end

  threads.each { |t| t.join }
end

puts "Execução dos programas 'IO-intensive' (download de arquivos):"
puts "-------------------------------------------------------------\n\n"

Benchmark.bm do |reporter|
  reporter.report { io_v1 }
  reporter.report { io_v2 }
  reporter.report { io_v3 }
end

puts "\n\n"
puts "Execução dos programas 'CPU-intensive (cálculo de fatorial)':"
puts "-------------------------------------------------------------\n\n"

Benchmark.bm do |reporter|
  reporter.report { cpu_v1 }
  reporter.report { cpu_v2 }
  reporter.report { cpu_v3 }
end

#
# Escreva as suas conclusões sobre como o desempenho variou para cada versão
# (melhorou ou piorou?) e para cada tipo de programa.
#
#print "\n\n Para programas IO-intensive o melhor tempo observado foi para 10 threads, pois "
#print "possivelmente 100 threads sobrecarrega o sistema, enquanto a versão sem threads é muito lenta\n"
#print "Para programas CPU-intensive o melhor tempo real observado foi para a versão sequencial, mas "
#print "o tempo de sistema melhorou, sendo 0 para ambas as versoes com threads"
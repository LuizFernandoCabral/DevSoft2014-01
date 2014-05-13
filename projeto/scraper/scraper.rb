# encoding:utf-8

require 'mechanize'

################################################
##           !USE YOUR CREDENTIALS            ##
################################################
USERNAME = 'aluno' # Use your username!
PASSWORD = '12345' # Use your password!

#
# Helper function that saves a HTML file on the html directory.
#
# @param [String] filename the name of the file to be saved.
# @param [String] body the body of the HTML file.
#
def save_html(filename, body)
  File.open("saved_html/#{filename}.html", "w") do |f|
    f.write(body.force_encoding('utf-8'))
  end
end

mechanize = Mechanize.new
mechanize.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36"

mechanize.get('http://estagios.pcs.usp.br/')
mechanize.get('http://estagios.pcs.usp.br/semLogin/login.aspx')

save_html('before_login', mechanize.page.body)

form = mechanize.page.forms[0]

headers = {
  'Host' => 'estagios.pcs.usp.br',
  'Connection'      => 'keep-alive',
  'Cache-Control'   => 'max-age=0',
  'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
  'Origin'          => 'http://estagios.pcs.usp.br',
  'Content-Type'    => 'application/x-www-form-urlencoded',
  'Referer'         => 'http://estagios.pcs.usp.br/semLogin/login.aspx',
  'Accept-Encoding' => 'gzip,deflate,sdch',
  'Accept-Language' => 'en-US,en;q=0.8,pt;q=0.6,de;q=0.4'
}

params = {
  '__EVENTTARGET'     => '',
  '__EVENTARGUMENT'   => '',
  '__VIEWSTATE'       => form.field_with(name: '__VIEWSTATE').value,
  '__EVENTVALIDATION' => form.field_with(name: '__EVENTVALIDATION').value,
  'ctl00$ContentPlaceHolder1$Login1$UserName'    => USERNAME,
  'ctl00$ContentPlaceHolder1$Login1$Password'    => PASSWORD,
  'ctl00$ContentPlaceHolder1$Login1$LoginButton' => 'Logar'
}

mechanize.post("http://estagios.pcs.usp.br/semLogin/login.aspx", params, headers)

save_html('after_login', mechanize.page.body)

mechanize.get('http://estagios.pcs.usp.br/aluno/vagas/listarVagasCadastradas.aspx')

save_html('vagas', mechanize.page.body)

doc = mechanize.page.parser 
selector = '#ContentPlaceHolder1_grdVagas'

arr = doc.css(selector).text
max = '0'

arr = arr.scan(/\d\d\d\d/)

for i in arr
  if i>max
    max = i
  end
end

vectorhash = []

for i in 1..max
  mechanize.get("http://estagios.pcs.usp.br/aluno/vagas/exibirVaga.aspx?id=#{i}")
  save_html("vagas#{i}", mechanize.page.body)

  mechanize.get("http://estagios.pcs.usp.br/aluno/vagas/exibirVaga.aspx?id=#{i}")
  save_html("vagas#{i}", mechanize.page.body)

  doc = mechanize.page.parser

  selector = '#ContentPlaceHolder1_lblHabilitacao'
  habilitacao = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblTitulo'
  titulo = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblEmpresa'
  empresa = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblArea'
  area = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblDescricao'
  descricao[i] = doc.css(selector).text

  selector = '#ContentPlaceHolder1_lblRequisitos'
  requisitos[i] = doc.css(selector).text

  selector = '#ContentPlaceHolder1_lblBeneficios'
  beneficios = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblContatos'
  contato = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblDataAnuncio'
  dataAnuncio = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblDataValidade'
  validade = doc.css.(selector).text

  selector = '#ContentPlaceHolder1_lblNumeroVagas'
  vagas[i] = doc.css.(selector).text

  vectorhash[i] = {
    "habilitacao" => habilitacao, "titulo" => titulo, "empresa" => empresa, "area" => area,
    "descricao" => descricao, "requisitos" => requisistos, "beneficios" => beneficios,
    "contato" => contato, "anuncio" => dataAnuncio, "validade" =>validade, "vagas" => vagas
  }

end

return_json = '{'

vectorhash.each do |elemento|
   return_json += '"' + elemento.code + '":'
   return_json += JSON.generate(elemento.data)
   return_json += ','
end

if (return_json != '}')
    return_json = return_json[0..-2]
end

return_json += '}'

File.open(projeto_json,"w") do |file|
    file.write(return_json)
end
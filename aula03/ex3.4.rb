def upcase(stringm)

	hash = {

	"a" => "A",
	"b" => "B",
	"c" => "C",
	"d" => "D",
	"e" => "E",
	"f" => "F",
	"g" => "G",

	"h" => "H",
	"i" => "I",
	"j" => "J",
	"k" => "K",
	"l" => "L",
	"m" => "M",
	"n" => "N",
	"o" => "O",
	"p" => "P",
	"q" => "Q",
	"r" => "R",
	"s" => "S",
	"t" => "T",
	"u" => "U",
	"v" => "V",
	"x" => "X",
	"w" => "W",
	"y" => "Y",
	"z" => "Z"
	}
	stringM=""

	stringm.each_char do |elemento|
		if hash[elemento] != nil
			stringM+=hash[elemento]

		else
			stringM+=elemento

		end
	stringM
	end
        return stringM
end

a = "introducao a ruby finalizada"
print upcase(a)

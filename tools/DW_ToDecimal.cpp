#include <iostream>
#include <string>
#include <vector>
#include <charconv>


struct StringWord {
	std::string word;
	bool HasCarriage = false;
};

std::string HexStringToDec(const std::string hexString){
	std::string hex = hexString;
	unsigned int value{};
    	auto [end, err] = std::from_chars(
    	    hex.data(),
    	    hex.data() + hex.size(),
    	    value,
    	    16
    	);

    	if (err == std::errc{} && end == hex.data() + hex.size()) {
		return std::string(std::to_string(value));
    	}

	return std::string("converr");
}

int main(int argc, char *argv[]) {
	if(argc != 2){
		std::cerr << "Usage: DW_ToDecimal <string>";
		return 1;
	}
	std::string upString = argv[1];
	std::string upWord = "";
	std::vector<StringWord> processVec;
	size_t position = 0;

	for(const auto& ch : upString){
		if(isalnum(ch)){
			upWord += ch;
		}
		else if(ch == ' ' or ch == '\n') {
			if(ch == ' '){
     				processVec.push_back({upWord});
     			}
			else{
				processVec.push_back({upWord, true});
			}
			upWord = "";
		}
		else{
			std::cerr << "Error: Cannot process char: '" << ch << "' at position " << position << std::endl
				<< "Result will be malformed, exiting early..." << std::endl;
			return 1;
		}
		position++;
	}	

	if(! upWord.empty()){
		processVec.push_back({upWord, true});
	}

	for(auto& word : processVec){
		// in the future, this can reverse words if needed.
//		if(word.word.length() == 4){
//			word.word = word.word.substr(2, 4) + word.word.substr(0,2);
//		}
		word.word = HexStringToDec(word.word);
	}

	for(const auto& word : processVec){
		if(word.HasCarriage){
     			std::cout << word.word << std::endl;
     		}
		else{
     			std::cout << word.word << " ";
     		}
	}
	
}

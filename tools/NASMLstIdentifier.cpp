#include "./Helpers.h"

#include <optional>
#include <fstream>
#include <string>


bool dwDetected(const std::string line){
	std::string code = line;
	size_t commentPos = line.find(';');
	if(commentPos != std::string::npos){
		code = line.substr(0, commentPos);
	}

	size_t pos = code.find("dw");
	if(pos == std::string::npos){
		pos = code.find("DW");
	}

	if(pos != std::string::npos && isStandaloneToken(code, pos, 2)){
		return true;
	}

	return false;
}

std::optional<std::string> findLabel(std::string& line) {
	std::string labelArea = line;
	size_t commentPos = line.find(';');
	if(commentPos != std::string::npos){
		labelArea = line.substr(0, commentPos);
	}

	size_t colonPos = labelArea.find(':');
	if(colonPos == std::string::npos){
		return std::nullopt;
	}
	
	// trim the spaces of the plausible area to isolate just non-space
	std::string plausibleLabel = TrimString(labelArea);
	colonPos = plausibleLabel.find(':');
	if(colonPos == std::string::npos){
		return std::nullopt;
	}

	plausibleLabel = extractTokenBefore(plausibleLabel, colonPos);

	if(!isValidNasmLabelName(plausibleLabel)){
		return std::nullopt;
	}

	return plausibleLabel;
}

std::optional<std::string> findLineNumber(std::string& line) {
	size_t firstSpace = line.find(' ');
	if(firstSpace == std::string::npos){
		return std::nullopt;
	}

	std::string lineNumber = extractTokenAfter(line, firstSpace);
	if(lineNumber == "") {
		return std::nullopt;
	}

	return lineNumber;
}

std::optional<std::string> findAddress(std::string line) {
	std::optional lineNumberO = findLineNumber(line);
	if(!lineNumberO) {
		return std::nullopt;
	}
	std::string lineNumber = *lineNumberO;
	if(lineNumber == ""){
		return std::nullopt;
	}
	
	size_t lineNumberPos = line.find(lineNumber);
	if(lineNumberPos == std::string::npos) {
		return std::nullopt;
	}

	std::string address1 = extractTokenAfter(line, lineNumberPos + lineNumber.length());

	return address1;
}

int main(int argv, char* argc[]) {
	if(argv != 2){
		std::cerr << "Usage: NASMDWDetection <.lst file>" << std::endl;
		return 1;
	}
	std::string inputFile = argc[1];
	std::ifstream asmFile(inputFile);

	if(!asmFile.is_open()){
		std::cerr << "Error: Unable to open file: " << inputFile << std::endl;
		return 1;
	}

	std::string line;
	std::string lineNumber;
	std::string prevline = "";
	std::string label;
	std::string address1;
	std::optional<std::string> container;
	size_t position;
	
	// Another note, a lst file always stores the address of a dw command on the same line.
	while(std::getline(asmFile, line)){
		if(dwDetected(line)) {
			container = findLabel(line);
			if(!container) {
				container = findLabel(prevline);
			}
			label = *container;

			container = findLineNumber(line);
			if(container) {
				lineNumber = *container;
			}
			else {
				lineNumber = "x";
			}

			container = findAddress(line);
			if(container) {
				address1 = *container;
			}
			else {
				address1 = "y";
			}

			std::cout << lineNumber << ' ' << label <<
			' ' << address1 << std::endl;
		}
		prevline = line;
	}

	asmFile.close();

	return 0;
}

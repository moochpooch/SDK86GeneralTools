#pragma once

#include <cctype>
#include <iostream>
#include <string>

// Any cahr that can legally be part of a name.

bool isNasmLabelStart(char c){
	unsigned char uc = static_cast<unsigned char>(c);

	return std::isalpha(uc)
		|| c == '_'
		|| c == '.'
		|| c == '?';
}

bool isValidNasmLabelIdentifierChar(char c){
	unsigned char uc = static_cast<unsigned char>(c);

	return std::isalpha(uc)
		|| c == '_'
	        || c == '$'
	        || c == '#'
	        || c == '@'
	        || c == '~'
	        || c == '.'
	        || c == '?';
}

bool isValidNasmLabelName(const std::string& label) {
	if(label.empty()) {
		return false;
	}

	if(!isNasmLabelStart(label[0])){
		return false;
	}

	for(char c : label){
		if(!isValidNasmLabelIdentifierChar(c)) {
     			return false;
		}
	}

	return true;
}

std::string TrimString(const std::string& s){
	size_t start = 0;
	size_t end = s.size();
	while(start < end &&
       		std::isspace(static_cast<unsigned char>(s[start]))) {
		start++;
	}

	end = s.size();

	while(end > start &&
       		std::isspace(static_cast<unsigned char>(s[end - 1]))) {
		end--;
	}

	return s.substr(start, end - start);
}

bool isIdentifierChar(char c) {
	return std::isalnum(static_cast<unsigned char>(c)) || c == '_';
}

bool isStandaloneToken(const std::string& line, size_t pos, size_t len) {
	// Standalone if before is empty, or there is NO id char before the token
	bool beforeOk = pos == 0 || !isIdentifierChar(line[pos - 1]);

	size_t after = pos + len;
	bool afterOk = after >= line.size() || !isIdentifierChar(line[after]);

	return beforeOk && afterOk;
}

//todo
//std::string extractTokenByPosition(const std::string& line, char c) {
//}

std::string extractTokenAfter(const std::string& line, size_t position) {
	size_t charPos = position;
	if(charPos == std::string::npos || charPos > line.length()) {
		return "";
	}
	
	size_t start = charPos;
	while(start < line.length() && std::isspace(static_cast<unsigned char>(line[start]))) {
		start++;
	}
	if(start == line.length()) {
		return "";
	}

	size_t end = start;
	while(end < line.length() && isIdentifierChar(line[end])) {
		end++;
	}

	return line.substr(start, end - start);	
}

std::string extractTokenBefore(const std::string& line, size_t position) {
	size_t charPos = position;
	if(charPos == std::string::npos || charPos > line.length()) {
		std::cout << "test";
		return "";
	}
	size_t end = charPos;

	while( end > 0 && std::isspace(static_cast<unsigned char>(line[end - 1]))){
		end--;
	}

	if(end == 0){
		return "";
	}
	size_t start = end;

	while(start > 0 && isValidNasmLabelIdentifierChar(line[start - 1])) {
		start--;
	}
	return line.substr(start, end - start);
}


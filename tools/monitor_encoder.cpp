#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector>

int main(int argc, char* argv[]){
	// Primary arg checks
	if(argc != 2){
		std::cerr << "Usage: monitor_encoder <filename>" << std::endl;
		return 1;
	}
	std::string filename = argv[1];
	std::ifstream file(filename, std::ios::binary);
	if(!file){
		std::cerr << "Unable to open file, is path valid?" << std::endl;
		return 1;
	}
	
	// Begin file read
	std::cout << std::hex << std::uppercase << std::setfill('0');
	std::vector<char> buffer(1024);
	std::vector<unsigned char> inter_buffer;
	std::vector<unsigned short int> formatted_buffer;

	while (file.read(buffer.data(), buffer.size()) || file.gcount() > 0) {
	        std::streamsize bytesRead = file.gcount();
		std::size_t old_size = inter_buffer.size();
		inter_buffer.resize(old_size + static_cast<size_t>(bytesRead));
		
		for(std::streamsize i = 0; i < bytesRead; i++){
			unsigned char byte = static_cast<unsigned char>(buffer[i]);
			inter_buffer.at(old_size + static_cast<std::size_t>(i)) = byte;
		}
	}

	// Odd Buffer case
	if (inter_buffer.size() % 2 != 0) {
		inter_buffer.resize(inter_buffer.size() + 1, 0);
	}

	unsigned char tmp;
	formatted_buffer.resize(inter_buffer.size() / 2);
	for (int i = 0, out = 0; i < inter_buffer.size() - 1; i += 2, out++) {
		tmp = inter_buffer.at(i);
		inter_buffer.at(i) = inter_buffer.at(i+1);
		inter_buffer.at(i+1) = tmp;
		formatted_buffer[out] =
        	(static_cast<unsigned short int>(inter_buffer[i]) << 8) |
        	 static_cast<unsigned short int>(inter_buffer[i + 1]);
	}

	// used for testing and comparing outputs between word and byte
	//for (const auto & data : inter_buffer) {
	//	std::cout << std::setw(2) << static_cast<unsigned short int>(data) << " ";
	//}
	
	for (const auto& data : formatted_buffer){
		std::cout << std::setw(4) << static_cast<unsigned short int>(data) << ",";
	}
}

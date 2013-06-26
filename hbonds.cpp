/*This code is used to analyze the output file vasp produces for plotting the number of hydrogen bonds per frame.*/

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main()
{
string infile;
ifstream inputfile;
ofstream outputfile;

double nooa;

cout << "Please enter your inputfile: ";
cin >> infile;
cout << "Please enter the number of oxygen atoms: ";
cin >> nooa;

inputfile.open(infile.c_str());
int frame, nohb;
int count = 0;
double sum = 0;
while (!inputfile.eof())
{
	inputfile >> frame >> nohb;
	sum += nohb;
	count ++;
	
}

cout << "The average number of hydrogen bonds per molecule is " << sum/((count-1)*nooa) + 2   << endl;


inputfile.close();
outputfile.close();

return 0;
}

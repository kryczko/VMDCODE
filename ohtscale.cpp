/* This program creates a histogram for the amount of time an OH group takes before it transfers to another O molecule*/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cmath>

using namespace std;


int pbc_round(double input)
{
	int i  = input;

	if (abs(input - i) >= 0.5)
	{
		if (input > 0) {i += 1;}
		if (input < 0) {i -= 1;}
	}
return i;
}
double max(vector <double> times)
{
	double value = times[0];
	for (int i = 1; i < times.size(); i ++)
	{
		if (times[i] > value)
		{
			value = times[i];
		}
	}
return value;
}

int main()
{
	string infile;
	double xlat, ylat, zlat, timestep;
	int nooa, noha;
	
	cout << "XYZ file\n==> ";
	cin >> infile;
	cout << "Lattice constants (x y z)\n==> ";
	cin >> xlat >> ylat >> zlat;
	cout << "Number of atoms (O H)\n==> ";
	cin >> nooa >> noha;
	cout << "Timestep (in femtoseconds)\n==> ";
	cin >> timestep;
 
	ifstream input;
	input.open(infile.c_str());
		
	string content;
	double xval, yval, zval;
	vector <double> ox, oy, oz, hx, hy, hz;

	while (! input.eof())
	{
		input >> content;
		if (content == "O")
		{
			input >> xval >> yval >> zval;
			ox.push_back(xval);
			oy.push_back(yval);
			oz.push_back(zval);
		}
		if (content == "H")
                {
                        input >> xval >> yval >> zval;
                        hx.push_back(xval);
                        hy.push_back(yval);
                        hz.push_back(zval);
                }

	}
	int nframes = ox.size()/nooa;	
	vector <int> loneO;
	
	for (int i = 0; i < nframes; i ++)
	{
		for (int j = 0; j < nooa; j ++)
		{
			int hcount = 0;
			for (int k = 0; k < noha; k ++)
			{
				double dx = ox[j + i*nooa] - hx[k + i*noha];
				double dy = oy[j + i*nooa] - hy[k + i*noha];
				double dz = oz[j + i*nooa] - hz[k + i*noha];
			
				dx -= xlat*pbc_round(dx/xlat);
				dy -= ylat*pbc_round(dy/ylat);
				dz -= zlat*pbc_round(dz/zlat);
				
				double dist = sqrt( dx*dx + dy*dy + dz*dz );
				
				if (dist <= 1.2)
				{
					hcount ++;	
				}
			}
			
			if (hcount == 1)
			{
				loneO.push_back(j);
			}
			
		}
	}
	
	ofstream output;
	output.open("OHtime.dat");
	int count = 0;	
	vector <double> timecount;	

	for (int i = 1; i < loneO.size(); i ++)
	{
		if (loneO[i] == loneO[i - 1])
		{
			count ++;
		}
		else
		{
			timecount.push_back(count);
			count = 0;
		}
	}
	for (int i = 2; i < loneO.size(); i ++)
	{
		if (loneO[i] == loneO[i - 2])
                {
                        count ++;
                }
                else
                {
                        timecount.push_back(count);
                        count = 0;
                }
	}

	int bin_num;
	double bin[20] = {};
	int finalcount = 0;

	for (int i = 0; i < timecount.size(); i ++)
	{
		if (timecount[i] != 0)
		{
			cout << timecount[i]*timestep << endl;	
			bin_num = int( timecount[i]*timestep)/10; 
			bin[bin_num] ++;
		}
	}
	
	for (int i = 0; i < 20; i ++)
	{
		output << i << "\t" << bin[i] << endl;
		output << i + 1 << "\t" << bin[i] << endl;
	}
	
	input.close();
	output.close();
	return 0;
}

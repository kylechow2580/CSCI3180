// # CSCI3180 Principles of Programming Languages
// # --- Declaration ---
// # I declare that the assignment here submitted is original except for source material explicitly
// # acknowledged. I also acknowledge that I am aware of University policy and regulations on
// # honesty in academic work, and of the disciplinary guidelines and procedures applicable to
// # breaches of such policy and regulations, as contained in the website
// # http://www.cuhk.edu.hk/policy/academichonesty/
// # Assignment 2
// # Name: CHOW Wai Kwong, Kyle
// # Student ID: 1155074568
// # Email Addr: 1155074568@link.cuhk.edu.hk

#include <iostream>
#include <string>
#include <typeinfo>
using namespace std;

class FoodBuying //Module in Ruby file
{
	public:
		void buyFood(string foodName, int payment)
		{
			cout << "Buy " << foodName << " and pay " << "$" << payment << "." << endl;
			pay(payment);
		}
		virtual void pay(int payment) = 0;
};

class Person : public FoodBuying //A abstract class type for inheritance and dynamic-casting
{	
	public:
		virtual void seeDoctor(int num) = 0;
		virtual string to_s() = 0;
		virtual void getDrugDispensed(int num) = 0;
		virtual void getSalary(int amount) = 0;
		virtual void attendClub() = 0;
};

//All function and data member refer to the original ruby file
class HospitalMember : public Person
{
	protected:
		string name;
		int nbDrugsDispensed;
	public:
		HospitalMember(string name, int nbDrugsDispensed=0)
		{
			this->name = name;
			this->nbDrugsDispensed = nbDrugsDispensed;
		}
		virtual string to_s() = 0;
		virtual void seeDoctor(int num)
		{
			cout << to_s() << " is sick! S/he sees a doctor." << endl;
		}
		void getDrugDispensed(int num)
		{
			int nbDrugsDispensed;
			if(this->nbDrugsDispensed < num)
			{
				nbDrugsDispensed = this->nbDrugsDispensed;
				this->nbDrugsDispensed = 0;
			}
			else
			{
				nbDrugsDispensed = num;
				this->nbDrugsDispensed -= num;
			}
			cout << "Dispensed " << nbDrugsDispensed << " drug items, " << this->nbDrugsDispensed << " items still to be dispensed." << endl;
		}
};


//All function and data member refer to the original ruby file
class Doctor : public HospitalMember
{
	private:
		string staffID;
		int salary;
	public:
		Doctor(string staffID, string name) : HospitalMember(name)
		{
			//Calling parent constructor to simulate super(name)
			this->staffID = staffID;
			salary = 100000;
		}
		string to_s()
		{
			return "Doctor " + name + " (" + staffID + ")";
		}
		void seeDoctor(int num)
		{
			//Calling parent virtual function seeDoctor to simulate super(name)
			HospitalMember::seeDoctor(num);
			nbDrugsDispensed += num;
			cout << "Totally " << this->nbDrugsDispensed << " drug items administered." << endl;
		}
		void getSalary(int amount)
		{
			this->salary += amount;
			//(Done)puts self.to_s + " has got HK$" + @salary.to_s + " salary left."
			cout << to_s() << " has got HK$" << this->salary << " salary left." << endl;
		}
		void pay(int amount)
		{
			this->salary -= amount;
			//(Done)puts self.to_s + " has got HK$" + @salary.to_s + " salary left."
			cout << to_s() << " has got HK$" << this->salary << " salary left." << endl;
		}
		void attendClub()
		{
			cout << "Eat and drink in the Club." << endl;
		}
};

class Patient : public HospitalMember
{
	private:
		string stuID;
		int money;
	public:
		Patient(string stuID, string name): HospitalMember(name)
		{
			//Calling parent constructor to simulate super(name)
			this->stuID = stuID;
			this->money = 10000;
		}
		string to_s()
		{
			return "Patient " + this->name + " (" + this->stuID + ")";
		}
		void seeDoctor(int num)
		{
			////Calling parent virtual function seeDoctor to simulate super(name)
			HospitalMember::seeDoctor(num);
			int max = 15;
			if(num < 15 - this->nbDrugsDispensed)
			{
				this->nbDrugsDispensed += num;
			}
			else
			{
				this->nbDrugsDispensed = max;
			}
			cout << "Totally " << this->nbDrugsDispensed << " drug items administered." << endl;
		}
		void pay(int amount)
		{
			this->money -= amount;
			cout << to_s() << " has got HK$" << this->money << " left in the wallet." << endl;
		}

		//Virtual function inherit from Person class, but useless in Patient class
		void getSalary(int amount){}
		void attendClub(){}
};

class Visitor : public Person
{
	private:
		string visitorID;
		int money;
	public:
		Visitor(string visitorID)
		{
			this->visitorID = visitorID;
			this->money = 1000;
		}
		string to_s()
		{
			return "Visitor " + visitorID;
		}
		void pay(int amount)
		{
			this->money -= amount;
			cout << to_s() << " has got HK$" << money << " left in the waller." << endl;
		}

		//Virtual function inherit from Person class, but useless in Visitor class
		void seeDoctor(int num){}
		void getDrugDispensed(int num){}
		void getSalary(int amount){}
		void attendClub(){}
};

class Pharmacy
{
	private:
		string pharmName;
	public:
		Pharmacy(string name)
		{
			this->pharmName = name;
		}
		string to_s()
		{
			return pharmName + "Pharmacy";
		}
		void dispenseDrugs(Person* person, int numOfDrugs)
		{
			// 	if person.respond_to?(:getDrugDispensed)
			// 		person.getDrugDispensed(numOfDrugs);
			// 	else
			// 		puts "#{person.to_s} is not a pharmacy user!"
			// Checking object type to simulate the ruby checking parent data member function
			if(typeid(*person)==typeid(Patient) || typeid(*person)==typeid(Doctor))
			{
				person->getDrugDispensed(numOfDrugs);
			}
			else
			{
				cout << person->to_s() << " is not a pharmacy user!" << endl;
			}
		}
};

class Canteen
{
	private:
		string ctnName;
	public:
		Canteen(string name)
		{
			this->ctnName = name;
		}
		string to_s()
		{
			return ctnName + " Canteen";
		}
		void sellNoodle(Person* person)
		{
			int price = 40;
			//(Done)person.buyFood("Noodle", price);
			person->buyFood("Noodle", price);
		}
};


class Department
{
	private:
		string deptName;
	public:
		Department(string name)
		{
			this->deptName = name;
		}
		string to_s()
		{
			return deptName + " Department";
		}
		void callPatient(Person* person, int amount)
		{
			// if person.respond_to?(:seeDoctor)
			// 	person.seeDoctor(amount);
			// else
			// 	puts "#{person.to_s} has no rights to get see a doctor!";
			// end
			//Checking object type to simulate the ruby checking parent data member function
			if(typeid(*person)==typeid(Patient) || typeid(*person)==typeid(Doctor))
			{
				person->seeDoctor(amount);
			}
			else
			{
				cout << person->to_s() << " has no rights to get see a doctor!" << endl;
			}

		}
		void paySalary(Person* person, int amount)
		{
			// if person.respond_to?(:getSalary)
			// 	puts to_s + " pays Salary $#{amount} to #{person.to_s}.";
			// 	person.getSalary(amount);
			// else
			// 	puts "#{person.to_s} has no rights to get salary from #{to_s}!";
			// end
			//Checking object type to simulate the ruby checking parent data member function
			if(typeid(*person)==typeid(Doctor))
			{
				cout << to_s() << " pays Salary $" << amount << " to " << person->to_s() << "." << endl;
				person->getSalary(amount);
			}
			else
			{
				cout << person->to_s() << " has no rights to get salary from " << to_s() << endl;
			}		
		}
};

class StaffClub
{
	private:
	string clubName;
	public:
		StaffClub(string name)
		{
			this->clubName = name;
		}
		string to_s()
		{
			return clubName + " Club";
		}
		void holdParty(Person* person)
		{
			// if person.respond_to?(:attendClub)
			// 	person.attendClub();
			// else
			// 	puts "#{person.to_s} has no rights to use facilities in the Club!";
			// end
			// Checking object type to simulate the ruby checking parent data member function
			if(typeid(*person)==typeid(Doctor))
			{
				person->attendClub();
			}
			else
			{
				cout << person->to_s() << " has no rights to use facilities in the Club!" << endl;
			}

		}
};

int main()
{
	cout << "Hospital Administration System:" << endl;
	Patient alice = Patient("p001", "Alice");
	Doctor bob = Doctor("d001", "Bob");
	Visitor visitor = Visitor("v001");
	Pharmacy mainPharm = Pharmacy("Main");
	Canteen bigCtn = Canteen("Big Big");
	Department ane = Department("A&E");
	StaffClub teaClub = StaffClub("Happy");


	//Using for-loop and array to replace each-loop in ruby
	//Every pointer which is needed to check type will being dynamic-casting
	//Passing a Person type pointer to each member function
	Person* ptr[3] = {&alice,&bob,&visitor};
	for(int i=0;i<3;i++)
	{
		Person* person = ptr[i];
		cout << endl;
		cout << (*person).to_s() << " enters CU Hospital ..." << endl;
		//A&E
		cout << (*person).to_s() << " enters " << ane.to_s() << "." << endl;
		ane.callPatient(dynamic_cast<Person*>(person), 20);
		//pharmacy
		cout << (*person).to_s() << " enters " << mainPharm.to_s() << "." << endl;
		mainPharm.dispenseDrugs(dynamic_cast<Person*>(person), 10);
		mainPharm.dispenseDrugs(dynamic_cast<Person*>(person), 25);
		//Canteen
		cout << (*person).to_s() << " enters " << bigCtn.to_s() << "." << endl;
		bigCtn.sellNoodle(dynamic_cast<Person*>(person));
		//A&E again
		cout << (*person).to_s() << " enters " << ane.to_s() << " again." << endl;
		ane.paySalary(dynamic_cast<Person*>(person), 10000);
		//clubName
		cout << (*person).to_s() << " enters " << teaClub.to_s() << "." << endl;
		teaClub.holdParty(dynamic_cast<Person*>(person));

	}
	return 0;
}
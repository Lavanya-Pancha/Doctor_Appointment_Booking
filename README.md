# hospital_management

  This is a Flutter app which will help you to add Doctor details , Patient details and create or book appointment for the patient to available doctor

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Backend Service

  This project uses Firebase- Cloud Firestore for storage, access of the data.
  
  
# Database Structure

```
  Appointment_data
		|
		|-Document ID   		// Automatic Generates
			|
			|- Patient name	
			|- Patient ID
			|- Doctor ID   		//Doctor Document id
			|- date				//Appointment date
			|- Severity			
			|- Specialized		// Which category doctor
			|- Status			//Status of the appointment


Doctor_data
		|
		|-Document ID   		// Automatic Generates
			|
			|- First name	
			|- Last name
			|- Doctor ID   		//Doctor id
			|- Phonenumber		
			|- Days				// Doctor duty days
			|- Specialized		// Doctor Specialization
			|- Count			// Doctor can take how many appointment per day



Patient_data
		|
		|-Document ID   		// Automatic Generates
			|
			|- First name	
			|- Last name
			|- Patient ID   	
			|- Phonenumber			
			|- Age			
			
```
   
   
   ## Important Functionalities Used
   
   Booking is approved based on selected doctor is available on selected date and also doctor's slot count for per day
   
   Cannot delete a Doctor or Patient When they have any appointment 
   
   Automatically deletes the appointment when date is expired and status is booked, if date is expired but status is still in Pending means, admin can change available date to approve the appointment or else they can reject the appointment
   
   
   ## Design Used
   
   Used Multiselect dropdown field using plugin and modified the plugin whenever app needs
   
   Used ```Flutter_easyloading ``` plugin for toast messages
   
   Used custom Progress for Page loading and used custom dialog box, listview
   
   
   
   
      
      

# Token Top-Up System
This repository contains a Ruby script that processes user data and their respective companies to assign token top-ups based on certain criteria.

### Overview
The Ruby script reads two JSON files, one containing user data and another with company data. Based on the instructions:

Active users from the companies listed will receive a token top-up.
Users with email_status set to true will be marked as emailed, but no actual emails are sent.
The output is sorted by company ID and then user last name.
The output is written to an output.txt file in a specified format.

### Prerequisites
Ruby (tested with version 2.x)
Installation & Setup
Clone this repository to your local machine:

### bash
Copy code
git clone https://github.com/dhwanil95/RubyProcessingTask.git
cd RubyProcessingTask
Ensure you have the required Ruby version installed.

### Usage
Ensure your user data is in a file named users.json and your company data is in companies.json within the directory.

### Run the script:

bash
Copy code
ruby challenge.rb
Check the generated output.txt for the results.

### Error Handling
The script contains error checks for:

Missing JSON files.
Invalid JSON format.
Expected data structure in JSON.

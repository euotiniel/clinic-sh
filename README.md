### Santa Muxima Clinic

Our final project of the discipline of Operating Systems I - Management of a clinic, lol. 

This is a fictional system with educational purposes dedicated to our learning of Shell Script. The idea was to build a system for a clinic that would demonstrate knowledge in the following areas (Linux):

- Basic Linux Commands;
- User and Group Management, permissions;
- File System: mounting, unmounting and directory structures;
- File system cleanup;
- Shell Scripting;
- Network environment configuration, log files;

Read about my contact with shell script: [link](https://euotiniel.com/blog/aprendendo-shellscript)

### Installation and Configuration

To install and configure the project locally, follow the steps below:

1. Leave a ⭐ on the repository.
2. Fork the project.
3. Clone the repository.
4. Run `./main.sh`

> All necessary dependencies will be automatically installed.

### Functionalities

The system offers the following functionalities:

#### For Administrators
- Create and delete administrators.
- Create and delete doctors.
- View logs.
- Do backup.
- Create and delete branches.
- Generate reports and lists.

#### For Doctors
- Carry out consultations.
- Carry out exams.
- View appointments and exams.
- Mark patients as dead.
- List patients and exams.

#### For Attendants (Employees)
- Schedule exams.
- Make appointments.
- List pending payments.
- List deceased patients.

#### For Patients
- Login and view results of consultations and exams (after payment).

### Project Structure

The project folder and file structure is as follows:

```sh
├── auth
│ ├── guest.sh
│ ├── login.sh
├── create
│ ├── backup.sh
│ ├── dead.sh
│ ├── filiates.sh
├── database
│ ├── ....
├── logs
│ ├── backup_error.log
│ ├── backup_info.log
│ ├── error.log
│ ├── system.log
├── nfs
│ ├── client.sh
│ ├── server.sh
├── tests
│ ├── demo.sh
│ ├── test.txt
├── users
│ ├── admin.sh
│ ├── doctor.sh
│ ├── patient.sh
├── config.sh
├── main.sh
├── README.md
```

### Data base

For educational reasons and simplicity, we use text files (.txt) 😂 as a database, where each line corresponds to a record. Some information is built into Linux, such as users and groups:

- Administrators and doctors are Linux users.
- Branches are groups.
- Patients are stored in .txt files.

To separate doctors and administrators, we use Linux IDs. IDs from 1000 to 1500, for example, are reserved for administrators, and the rest are for doctors.

### Libraries and Tools

The main libraries and tools used in the project are:

- Shell Script (bash)
- Finger (`sudo apt-get install finger`)
- NFS Server and Client

### Authors and Acknowledgments

The project was developed by:

- Otoniel Emanuel
- Francisco Luvumbo
- Sabahote Miguel
- Abel Rosinho
- Fabiana Giliane

Special thanks to Professor of Operating Systems I.

### Contribution

To contribute to the project, follow the steps below:

1. ⭐ the repository.
2. Fork the project.
3. Clone the repository.
4. Analyze the code.
5. Add your features.
6. Submit a pull request.

### License

This project is student work and does not have a specific license. Feel free to use it for educational and teaching purposes.

---

🏎💨 We hope this project is useful for learning and developing skills in Shell Script and operating system administration.



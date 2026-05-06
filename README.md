
---

# 📚 Library Loan System – Haskell

## 📌 Project Overview

This project implements a **Library Loan Management System** using **Haskell**, focused on handling book loans and returns while storing all data in a `.txt` file.

The system demonstrates how functional programming can be used to manage real-world data, combining:

* File persistence (TXT storage)
* Data parsing
* Functional logic for managing loans

---

## 🧠 What This Project Does

✔️ Registers books and/or users
✔️ Manages book loans
✔️ Handles returns
✔️ Stores and retrieves data from a `.txt` file
✔️ Parses text data into structured information

---

## ⚙️ How It Works

The system uses **file handling in Haskell** to persist information.

* Data is stored in a `.txt` file
* Each operation reads, modifies, and rewrites the file
* The program transforms raw text into usable data structures

In Haskell, this is typically done using functions like:

* `readFile` → to read stored data
* `writeFile` → to overwrite data
* `appendFile` → to add new records

These functions are part of Haskell’s I/O system and allow interaction with external files ([shinyu.org][1])

---

## 🏗️ Project Structure

Although implementation may vary, the system is logically divided into:

* **Data Model**

  * Representation of books, users, and loans

* **File Handler**

  * Reads and writes `.txt` files
  * Converts text into structured data

* **Loan Logic**

  * Borrow book
  * Return book
  * Validate availability

* **Main Program**

  * Handles user interaction (CLI)

---

## 🧪 Example Data Format (TXT)

The `.txt` file might store information like:

```
BookID,Title,Author,Available
1,The Hobbit,Tolkien,Yes
2,1984,Orwell,No
```

Or loans:

```
UserID,BookID,LoanDate
101,2,2025-03-10
```

---

## 🚀 How to Run the Project

1. Clone the repository:

   ```bash
   git clone https://github.com/Jjeronimo17/Practica1.git
   ```

2. Open the project in your preferred editor (VS Code / IntelliJ / etc.)

3. Make sure you have **GHC (Glasgow Haskell Compiler)** installed

4. Run the program:

   ```bash
   runghc Main.hs
   ```

   or compile:

   ```bash
   ghc Main.hs
   ./Main
   ```

---

## 🎯 Learning Objectives

This project helped develop skills in:

* Functional programming with Haskell
* File handling and persistence
* Data parsing and transformation
* Managing state without mutable variables
* Designing simple backend systems

---

## 🧩 Key Concepts Used

* Pure functions
* I/O Monad
* File handling (`System.IO`)
* Pattern matching
* Lists and recursion

---

## 👨‍💻 Author

* **Jeronimo Jaramillo Agudelo**

---

## 🏫 Academic Context

* **University:** EAFIT
* **Course:** Programming Fundamentals / Functional Programming
* **Language:** Haskell

---

## 💡 Possible Improvements

* Add user authentication
* Implement a graphical interface (GUI)
* Migrate from `.txt` to a database
* Add search and filtering features
* Improve error handling

---

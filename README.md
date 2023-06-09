# **Disclaimer: Learn at your own discretion, and if you don't have a life, proceed without caution**

Learning and exploring new topics, such as assembly language and data structures, can be exciting and rewarding. However, it is essential to strike a balance between learning and taking care of your physical and mental health, as well as fulfilling your personal and professional responsibilities.

Please remember:

1. **Take breaks**: Engage in regular breaks, physical activity, and relaxation to avoid excessive screen time and maintain a healthy lifestyle.

2. **Prioritize your obligations**: Ensure that you fulfill your personal, academic, or professional responsibilities before dedicating time to learning new skills or hobbies.

3. **Seek professional guidance**: If you have any underlying health conditions or concerns, consult with medical or mental health professionals to ensure that your learning activities are compatible with your well-being.

Remember, learning should be an enjoyable and enriching experience, but not at the expense of your overall well-being. Take care of yourself, set realistic goals, and enjoy your learning journey responsibly.


# Assembly DSA Toolkit

Welcome to the Assembly DSA Toolkit repository! This repository provides an x64 assembly implementation of essential data structures and algorithms for DSA.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
- [Contributing](#contributing)

## Introduction

The Assembly DSA Toolkit aims to offer a comprehensive collection of data structures and algorithms implemented in x64 assembly language. By providing low-level implementations, this toolkit allows developers to explore the inner workings of fundamental DSA concepts and gain a deeper understanding of assembly programming.

## Features

- Implementation of common data structures such as arrays, linked lists, stacks, queues, and trees in x64 assembly.
- Efficient algorithms for searching, sorting, graph traversal, and other important DSA operations.
- Modular and well-commented code for easy understanding and modification.
- Sample applications and test cases to demonstrate the usage and correctness of the implemented DSA components.
- Educational resources and documentation to aid in learning assembly language and DSA concepts.

## Getting Started

To get started with the Assembly DSA Toolkit, follow these steps:

1. Clone the repository:https://github.com/Malwareman007/x64-DSA-Assembly.git
2. Browse the available data structures and algorithms in the repository's folders.
3. Open the desired implementation in an x64 assembly compatible environment.
4. Explore the code, comments, and function definitions to understand how the DSA component works.
5. Modify and experiment with the code to suit your needs or integrate it into your projects.

## How to compile code in linux 
1. let the file name be `stack.asm`
2. Install NASM if you don't have it already.`sudo apt update` `sudo apt install nasm`
3. Assemble the code using the following command: `nasm -f elf64 stack.asm -o stack.o`
4. Link the object file and create an executable using the following command: `ld stack.o -o stack`
5. Run the program by executing `./stack.`


## How to install Assembley in Windows.
See in this [Blog](https://medium.com/@malwareman007/how-to-install-masm-microsoft-assembler-on-windows-10-8-1-8-and-7-step-by-step-guide-df5fd9dca599)
**or** 
* Install WSL: Open the Microsoft Store and search for "Linux" to find various Linux distributions. Choose and install the one you prefer (e.g., Ubuntu, Debian).
* Launch WSL: Once the installation is complete, open the installed Linux distribution from the Start menu or by searching for its name. It will open a command line interface for the Linux environment.
* Transfer the code: In the Linux terminal, you can transfer the assembly code file (e.g., stack.asm) to the Linux environment. You can do this in several ways, such as using scp or sharing a folder between Windows and WSL.
* Install NASM: Inside the Linux environment, install NASM by running the following command:
`sudo apt update`
`sudo apt install nasm`
* Assemble and link the code: In the Linux terminal, navigate to the directory where you transferred the assembly code file. Then, assemble and link the code using the following commands:`nasm -f elf64 stack.asm -o stack.o` <br>
`ld stack.o -o stack`
* Run the program: Finally, execute the program by running the following command:
`./stack`

## Contributing

Contributions are welcome! If you would like to contribute to the Assembly DSA Toolkit, please follow these steps:

1. Fork the repository.
2. Create a new branch for your contribution.
3. Make your changes and ensure the code remains well-documented.
4. Test your changes to ensure they do not introduce any errors or bugs.
5. Commit and push your changes to your forked repository.
6. Submit a pull request, describing your changes and the motivation behind them.


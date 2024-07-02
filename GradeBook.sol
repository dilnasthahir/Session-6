// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradeBook {
    // Struct
    struct Grade {
        string studentName;
        string subject;
        uint8 grade; 
    }

    // Array 
    Grade[] public grades;

    // Contract owner (instructor)
    address public owner;

    // Modifier to restrict access
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    // Constructor to initialize the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to add a new grade of a student
    function addGrade(string memory _studentName, string memory _subject, uint8 _grade) public onlyOwner {
        require(_grade <= 100, "Grade must be between 0 and 100");
        grades.push(Grade(_studentName, _subject, _grade));
    }

    // Function to update the grade of a student for a specific subject
    function updateGrade(string memory _studentName, string memory _subject, uint8 _newGrade) public onlyOwner {
        require(_newGrade <= 100, "Grade must be between 0 and 100");
        for (uint i = 0; i < grades.length; i++) {
            if (keccak256(abi.encodePacked(grades[i].studentName)) == keccak256(abi.encodePacked(_studentName)) &&
                keccak256(abi.encodePacked(grades[i].subject)) == keccak256(abi.encodePacked(_subject))) {
                grades[i].grade = _newGrade;
                return;
            }
        }
        revert("Grade not found for the specified student and subject");
    }

    // Function to retrieve the grade of a student for a particular subject
    function getGrade(string memory _studentName, string memory _subject) public view returns (uint8) {
        for (uint i = 0; i < grades.length; i++) {
            if (keccak256(abi.encodePacked(grades[i].studentName)) == keccak256(abi.encodePacked(_studentName)) &&
                keccak256(abi.encodePacked(grades[i].subject)) == keccak256(abi.encodePacked(_subject))) {
                return grades[i].grade;
            }
        }
        revert("Grade not found for the specified student and subject");
    }

    // Function to calculate and return the average grade of all students for a specific subject
    function averageGrade(string memory _subject) public view returns (uint8) {
        uint totalGrades = 0;
        uint count = 0;

        for (uint i = 0; i < grades.length; i++) {
            if (keccak256(abi.encodePacked(grades[i].subject)) == keccak256(abi.encodePacked(_subject))) {
                totalGrades += grades[i].grade;
                count++;
            }
        }

        require(count > 0, "No grades found for the specified subject");

        return uint8(totalGrades / count);
    }
}

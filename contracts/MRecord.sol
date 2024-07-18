// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract MRecord {

    struct Patient {
        string name;
        string dob;
        string weight;
        string bloodgroup;
        string allergies;
        string medication;
        uint date;
    }

    struct Doctor {
        string ic;
        string name;
        string phone;
        string qualification;
        string major;
        address addr;
        uint date;
    }

    address public owner;
    address[] public patientList;
    address[] public doctorList;

    mapping(address => Patient) public patients;
    mapping(address => Doctor) public doctors;

    mapping(address => mapping(address => bool)) public isApproved;
    mapping(address => bool) public isPatient;
    mapping(address => bool) public isDoctor;
    //mapping(address => uint) public appointmentCountPerPatient;

    uint256 public patientCount = 0;
    uint256 public doctorCount = 0;
    // uint256 public appointmentCount = 0;
    uint256 public permissionGrantedCount = 0;

    constructor() {
        owner = msg.sender;
    }

    function setDetails(string memory _name,   string memory _dob,  string memory _weight,  string memory _bloodgroup, string memory _allergies, string memory _medication) public {
        require(!isPatient[msg.sender]);
        Patient storage p = patients[msg.sender];
    
        p.name = _name;
        p.dob = _dob;
        p.weight = _weight;
    
    // Call internal function to set diagnostic details
        setDiagnosticDetails(_bloodgroup, _allergies, _medication, p);
    
        p.date = block.timestamp;
    
        patientList.push(msg.sender);
        isPatient[msg.sender] = true;
        patientCount++;
}

// Internal function to set diagnostic details
    function setDiagnosticDetails(string memory _bloodgroup, string memory _allergies, string memory _medication, Patient storage p) internal {
        p.bloodgroup = _bloodgroup;
        p.allergies = _allergies;
        p.medication = _medication;
}

    function setDoctor(string memory _ic, string memory _name, string memory _phone,string memory _qualification, string memory _major) public {
        require(!isDoctor[msg.sender]);
        Doctor storage d = doctors[msg.sender];
        
        d.ic = _ic;
        d.name = _name;
        d.phone = _phone;
        d.qualification = _qualification;
        d.major = _major;
        d.addr = msg.sender;
        d.date = block.timestamp;
        
        doctorList.push(msg.sender);
        isDoctor[msg.sender] = true;
        doctorCount++;
    }

        function givePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = true;
        permissionGrantedCount++;
        return true;
    }

    function revokePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = false;
        return true;
    }

    function getPatients() public view returns(address[] memory) {
        return patientList;
    }

    function getDoctors() public view returns(address[] memory) {
        return doctorList;
    }

    function searchPatientDemographic(address _address) public view returns(string memory, string memory, string memory) {
        require(isApproved[_address][msg.sender]);
        
        Patient memory p = patients[_address];
        
        return (p.name, p.dob, p.weight);
    }

    function searchPatientMedical(address _address) public view returns(string memory, string memory, string memory) {
        require(isApproved[_address][msg.sender]);
        
        Patient memory p = patients[_address];
        
        return ( p.bloodgroup, p.allergies, p.medication);
    }   

    function searchDoctor(address _address) public view returns(string memory, string memory, string memory, string memory, string memory) {
        require(isDoctor[_address]);
        
        Doctor memory d = doctors[_address];
        
        return (d.ic, d.name, d.phone, d.qualification, d.major);
    }
    
    function searchRecordDate(address _address) public view returns(uint) {
        Patient memory p = patients[_address];
        
        return (p.date);
    }

    function searchDoctorDate(address _address) public view returns(uint) {
        Doctor memory d = doctors[_address];
        
        return (d.date);
    }

    function getPatientCount() public view returns(uint256) {
        return patientCount;
    }

    function getDoctorCount() public view returns(uint256) {
        return doctorCount;
    }

    function getPermissionGrantedCount() public view returns(uint256) {
        return permissionGrantedCount;
    }

}




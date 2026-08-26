package com.ai.poc.data;

import java.util.List;

public record EmployeeAuditData(
    String employeeId, 
    String fullName, 
    String department, 
    String jobTitle, 
    List<RoleAssignment> roles
) {}

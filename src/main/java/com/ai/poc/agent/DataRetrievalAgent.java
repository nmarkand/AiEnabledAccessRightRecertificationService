package com.ai.poc.agent;


import com.ai.poc.data.EmployeeAuditData;
import com.ai.poc.data.EmployeeRequest;
import com.ai.poc.data.RoleAssignment;
import com.ai.poc.db.entities.Employee;
import com.ai.poc.db.repos.EmployeeRepository;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DataRetrievalAgent {

    private final EmployeeRepository employeeRepository;

    public DataRetrievalAgent(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }

    @Tool(description = "Fetches complete relational data for an employee, including their department, job title, and currently assigned roles from the IAM database. Requires the employeeId (e.g., EMP101).")
    public EmployeeAuditData fetchEmployeeData(String employeeId) {
        System.out.println("🤖 [Subagent] Orchestrator requested data via JPA for: " + employeeId);

        Employee employee = employeeRepository.findByEmployeeId(employeeId)
            .orElseThrow(() -> new IllegalArgumentException("Employee not found: " + employeeId));

        List<RoleAssignment> roleAssignments = employee.getEmployeeRoles().stream()
            .map(er -> new RoleAssignment(
                er.getRole().getRoleCode(),
                er.getRole().getRiskLevel(),
                er.getGrantedDate(),
                er.getLastLoginDate()
            ))
            .toList();

        return new EmployeeAuditData(
            employee.getEmployeeId(),
            employee.getFullName(),
            employee.getDepartment(),
            employee.getJobTitle(),
            roleAssignments
        );
    }
}
package com.ai.poc.db.repos;

import com.ai.poc.db.entities.Employee;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, String> {

    // Uses EntityGraph to fetch employee and associated roles in a single query
    @EntityGraph(attributePaths = {"employeeRoles", "employeeRoles.role"})
    Optional<Employee> findByEmployeeId(String employeeId);
}
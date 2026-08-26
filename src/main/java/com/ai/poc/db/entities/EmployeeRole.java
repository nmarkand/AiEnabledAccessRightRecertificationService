package com.ai.poc.db.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "employee_roles", schema = "iam_data")
public class EmployeeRole {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id")
    private Employee employee;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_code")
    private Role role;

    @Column(name = "granted_date")
    private String grantedDate;

    @Column(name = "last_login_date")
    private String lastLoginDate;

    // Constructors
    public EmployeeRole() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Employee getEmployee() { return employee; }
    public void setEmployee(Employee employee) { this.employee = employee; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public String getGrantedDate() { return grantedDate; }
    public void setGrantedDate(String grantedDate) { this.grantedDate = grantedDate; }

    public String getLastLoginDate() { return lastLoginDate; }
    public void setLastLoginDate(String lastLoginDate) { this.lastLoginDate = lastLoginDate; }
}
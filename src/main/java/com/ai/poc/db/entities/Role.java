package com.ai.poc.db.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "roles", schema = "iam_data")
public class Role {

    @Id
    @Column(name = "role_code")
    private String roleCode;

    @Column(name = "risk_level")
    private String riskLevel;

    @Column(name = "description")
    private String description;

    // Constructors
    public Role() {}

    // Getters and Setters
    public String getRoleCode() { return roleCode; }
    public void setRoleCode(String roleCode) { this.roleCode = roleCode; }

    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
package com.ai.poc.data;

public record RoleAssignment(
    String roleCode, 
    String riskLevel, 
    String grantedDate, 
    String lastLoginDate
) {}
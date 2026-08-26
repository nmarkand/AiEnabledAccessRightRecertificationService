package com.ai.poc.data;

// The input payload expected from the LLM when it calls this tool
public record EmployeeRequest(String employeeId) {}
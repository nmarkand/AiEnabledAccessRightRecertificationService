package com.ai.poc.controller;

import com.ai.poc.agent.OrchestratorAgent;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuditController {

    private final OrchestratorAgent orchestratorAgent;

    public AuditController(OrchestratorAgent orchestratorAgent) {
        this.orchestratorAgent = orchestratorAgent;
    }

    @GetMapping("/audit")
    public String runAudit(@RequestParam String employeeId) {
        return orchestratorAgent.triggerAudit(employeeId);
    }
}
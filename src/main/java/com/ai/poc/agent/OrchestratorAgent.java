package com.ai.poc.agent;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.vectorstore.QuestionAnswerAdvisor;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Service;

@Service
public class OrchestratorAgent {

    private final ChatClient chatClient;

    public OrchestratorAgent(ChatClient.Builder chatClientBuilder,
                             DataRetrievalAgent dataRetrievalAgent,
                             VectorStore vectorStore) {
        this.chatClient = chatClientBuilder
                .defaultSystem("""
                You are the Enterprise IAM Compliance Orchestrator.
                Your job is to audit employee access rights and identify policy violations 
                by strictly referencing the retrieved enterprise compliance policies (PAM, SoD, and Vendor rules).
                
                Workflow:
                1. Use the 'fetchEmployeeData' tool to get the employee's current department, roles, and identifier.
                2. Base your compliance evaluation strictly on the retrieved document context.
                3. Output a strict response detailing if the user is COMPLIANT or NON_COMPLIANT, citing the specific policy rules violated if any.
                """)
                .defaultTools(dataRetrievalAgent)
                .defaultAdvisors(QuestionAnswerAdvisor.builder(vectorStore).build())
                .build();
    }

    public String triggerAudit(String employeeId) {
        System.out.println("🧠 [Orchestrator] Starting policy-backed audit for: " + employeeId);

        String auditReport = chatClient.prompt()
                .user("Perform a strict compliance audit on employee ID: " + employeeId + " using the official enterprise policies.")
                .call()
                .content();

        System.out.println("\n================ AI COMPLIANCE AUDIT REPORT ================\n");
        System.out.println(auditReport);
        System.out.println("\n===========================================================\n");

        return auditReport;
    }
}
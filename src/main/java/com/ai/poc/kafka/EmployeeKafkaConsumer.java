package com.ai.poc.kafka;

import com.ai.poc.agent.OrchestratorAgent;
import com.ai.poc.kafka.dto.EmployeeCdcEvent;
import com.ai.poc.kafka.dto.EmployeeRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

@Service
public class EmployeeKafkaConsumer {

    private final OrchestratorAgent orchestratorAgent;

    public EmployeeKafkaConsumer(OrchestratorAgent orchestratorAgent) {
        this.orchestratorAgent = orchestratorAgent;
    }

    @KafkaListener(topics = "iam_cdc.iam_data.employees", groupId = "ai-compliance-group")
    public void listenToEmployeeChanges(@Payload(required = false) EmployeeCdcEvent event) {
        try {
            if (event != null) {
                // Extract from 'after' (inserts/updates) or fallback to 'before' (deletes)
                EmployeeRecord employee = event.getAfter() != null ? event.getAfter() : event.getBefore();

                if (employee != null && employee.getEmployeeId() != null) {
                    String employeeId = employee.getEmployeeId();
                    System.out.println("📬 Avro Event received for employee ID: " + employeeId);
                    orchestratorAgent.triggerAudit(employeeId);
                } else {
                    System.out.println("🗑️ Delete event received or empty payload.");
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Error processing Avro Kafka message: " + e.getMessage());
        }
    }
}
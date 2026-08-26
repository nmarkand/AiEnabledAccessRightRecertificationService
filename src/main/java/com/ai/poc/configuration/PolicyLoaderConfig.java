package com.ai.poc.configuration;

import org.springframework.ai.document.Document;
import org.springframework.ai.reader.pdf.PagePdfDocumentReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ResourceLoader;

import java.util.List;

@Configuration
public class PolicyLoaderConfig {

    @Bean
    CommandLineRunner loadPoliciesIntoVectorStore(VectorStore vectorStore, ResourceLoader resourceLoader) {
        return args -> {
            // Load the 3 PDF policy files from your rag.policy folder
            loadPdfPolicy(vectorStore, resourceLoader.getResource("classpath:rag/policy/Privileged_Access_Management_Policy.pdf"));
            loadPdfPolicy(vectorStore, resourceLoader.getResource("classpath:rag/policy/Segregation_of_Duties_Policy.pdf"));
            loadPdfPolicy(vectorStore, resourceLoader.getResource("classpath:rag/policy/Third_Party_and_Contractor_Access.pdf"));

            System.out.println("📚 Enterprise compliance policies successfully loaded into VectorStore!");
        };
    }

    private void loadPdfPolicy(VectorStore vectorStore, org.springframework.core.io.Resource resource) {
        // Use PagePdfDocumentReader since these are PDF documents
        PagePdfDocumentReader pdfReader = new PagePdfDocumentReader(resource);
        List<Document> documents = pdfReader.get();

        TokenTextSplitter textSplitter = TokenTextSplitter.builder()
                .withChunkSize(300)
                .withMinChunkSizeChars(50)
                .withMinChunkLengthToEmbed(5)
                .withMaxNumChunks(10000)
                .withKeepSeparator(true)
                .build();

        List<Document> splitDocs = textSplitter.split(documents);
        vectorStore.add(splitDocs);
    }
}
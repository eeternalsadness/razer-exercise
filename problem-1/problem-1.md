# Problem 1

## Problem Statement

Team Snake is working on a new project that serves payment services globally. They have the
following services to be deployed:

- Web server
- External API Service
- Internal API Service
- Payment Processor Integration Service
- Redis Cache
- Relational Database

Please provide a network architecture diagram, as well as suitable solutions that considers
Security, High Availability / Reliability, Scalability, Performance and Observability.

## Assumptions

- **Global service**:
  - The service needs to be available globally, so a public cloud solution is appropriate
  - The service likely needs to be deployed in multiple regions to ensure quality of service and availability/disaster recovery
  - Each region likely has its own payment processors with different regulations, so there is no need for inter-region communication
- **External/Internal API service**:
  - External and internal users/systems interact through APIs, so API gateways are necessary
- **Payment processor integration service**:
  - The system integrates with an external payment processor which does most of the heavy lifting (checking balance, fraud detection, money transfers, etc.)

## Requirements

### Functional Requirements

- A user-facing web front that's available globally
- Interaction with external and internal services through APIs
- Deploy the following services:
  - External API service
  - Internal API service
  - Payment processor integration service
- Ability to handle large transaction volumes (thousands of requests per second)
- Use an ACID-compliant relational database to store financial transactions
- Use Redis as cache for the database(s)

### Non-functional Requirements

- The system should be highly available
- Data should be encrypted at rest and in transit
- Compliance with standards such as PCI DSS or KYC
- Requests should have low latency

## High-Level Design

## Considerations

### Security

### High Availability/Reliability

### Scalability

### Performance

### Observability
